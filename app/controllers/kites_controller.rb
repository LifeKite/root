# Author::    Rich Nagle  (mailto:rwnagle3+lifekite@gmail.com)
# Copyright:: Copyright (c) 2013 Lifekite, LLC

# This class exposes methods to manipulate kite objects and their
# associated assets (such as comments)
require 'nokogiri'
require 'open-uri'
require 'fastimage'
require 'will_paginate/array'

class KitesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :kite_general_search, :userPublicKitesIndex]
  before_filter :verify_is_admin_or_owner, :only => [:delete, :destroy]
  before_filter :verify_is_owner, :only => [:edit, :update, :complete, :ShareKiteToSocialMedia, :Join, :Unjoin]

  helper KitesHelper


  # Show the public and shared kites of a given user
  def userPublicKitesIndex
    check_and_handle_kites_per_page_update(current_user, params)

    @username = params[:username]
    @function = "#{params[:username]}'s kites"
    @kites = Kite.public_kites.joins(:user).where("users.username" => params[:username]).paginate(:page => params[:page], :per_page => @kitesPerPage)
    get_common_stats()

    respond_to do |format|
      format.html { render :template => 'kites/indexPublic' }# indexPublic.html.erb
      format.xml  { render :xml => @kites }
      format.js   { render :template => 'kites/indexPublic' }
    end

  end

  # Hashtag search
  def hashIndex
    check_and_handle_kites_per_page_update(current_user, params)
    @function = "#{params[:tag]} kites"

    @kites = Kite.TagSearch(current_user.id, params[:tag]).paginate(:page => params[:page], :per_page => @kitesPerPage)
    get_common_stats()
    respond_to do |format|
      format.html { render :template => 'kites/index' }# index.html.erb
      format.xml  { render :xml => @kites }
      format.js   { render :template => 'kites/index' }
    end

  end

  # List all kites
  def index
    time_range = (1.week.ago..Time.now)

    get_common_stats()

    if current_user
      @function = "Welcome #{current_user.KosherUsername}"
      kiteIDs = current_user.follwing.collect{|a| a.kite_id}.flatten
      @tied_kites = Kite.find(kiteIDs).paginate(:page => params[:page], :per_page => KITES_PER_PAGE * 3)

      @my_kites = current_user.kites.paginate(:page => params[:page], :per_page => KITES_PER_PAGE)
      @kites = Kite.public_kites.shuffle.paginate(:page => params[:page], :per_page => KITES_PER_PAGE * 3)
    else
      @kites = Kite.public_kites.shuffle.paginate(:page => params[:page], :per_page => KITES_PER_PAGE)
    end

    respond_to do |format|
      format.html { render :template => 'kites/redesigned-index' }# index.html.erb
      format.xml  { render :xml => @kites }
      format.js   { render :template => 'kites/index' }
    end
  end

  # List new kites only
  def newIndex
     time_range = (1.week.ago..Time.now)

     check_and_handle_kites_per_page_update(current_user, params)

     @kites = Kite.new_kites(time_range).paginate(:page => params[:page], :per_page => @kitesPerPage)
     get_common_stats()
     @function = "New Kites"

    respond_to do |format|
      format.html { render :template => 'kites/index' }# index.html.erb
      format.xml  { render :xml => @kites }
      format.js   { render :template => 'kites/index' }
    end
  end

  # List completed kites only
  def completedIndex
     time_range = (1.week.ago..Time.now)

     check_and_handle_kites_per_page_update(current_user, params)

     @kites = Kite.completed_kites.paginate(:page => params[:page], :per_page => @kitesPerPage)
     get_common_stats()
     @function = "Completed Kites"

    respond_to do |format|
      format.html { render :template => 'kites/index' }# index.html.erb
      format.xml  { render :xml => @kites }
      format.js   { render :template => 'kites/index' }
    end
  end

  # Show my kites
  def personalIndex
    check_and_handle_kites_per_page_update(current_user, params)

     @kites = current_user.kites.paginate(:page => params[:page], :per_page => @kitesPerPage)
     get_personal_stats()


    respond_to do |format|
      format.html { render :template => 'kites/index' } # index.html.erb
      format.xml  { render :xml => @kites }
      format.js   { render :template => 'kites/index' }
    end
  end

  # Show kites I follow and support
  def mySupportIndex
    check_and_handle_kites_per_page_update(current_user, params)

     @kiteIDs = current_user.follwing.collect{|a| a.kite_id}.flatten
     @kites = Kite.find(@kiteIDs).paginate(:page => params[:page], :per_page => @kitesPerPage)
     get_personal_stats()

     @function = "Member Kites"

    respond_to do |format|
      format.html { render :template => 'kites/index' } # index.html.erb
      format.xml  { render :xml => @kites }
      format.js   { render :template => 'kites/index' }
    end
  end


  def kite_general_search

    @text = params[:text]
    searchresults = []

    #do a more general search of kite names, descriptions and details
    searchresults = (searchresults + Kite.where(Kite.arel_table[:Description].matches("%#{@text}%").or(Kite.arel_table[:Details].matches("%#{@text}%")))).uniq
    searchresults = (searchresults + User.where(User.arel_table[:username].matches("%#{@text}%").or(User.arel_table[:firstname].matches("%#{@text}%")).or(User.arel_table[:lastname].matches("%#{@text}%"))))
    @function = "Search Results"
    check_and_handle_kites_per_page_update(current_user, params)

    @kites = searchresults.paginate(:page => params[:page], :per_page => @kitesPerPage)
    get_common_stats()
    respond_to do |format|
      format.html { render :template => 'kites/index' }# index.html.erb
      format.xml  { render :xml => @kites }
      format.js   { render :template => 'kites/index' }
    end
  end

  # Open the view for a given kite
  def show
    @kite = Kite.find(params[:id])

    #Queue up a proto-comment
    @comment = Comment.new
    @comments = @kite.comments.order("created_at DESC").paginate(:page => params[:commentpage], :per_page => COMMENTS_PER_PAGE)

    #Queue up a proto-kitepost
    @kitePost = KitePost.new
    @kitePosts = @kite.kitePosts.order("created_at DESC").paginate(:page => params[:postpage], :per_page => KITE_POSTS_PER_PAGE)

    @showComments = params.has_key?(:showComments)
    @showPosts = params.has_key?(:showPosts)
    @showFollowings = params.has_key?(:showFollowings)


    if @kite.UserCanView(current_user)

    else
     redirect_to(current_user, :error => "The kite you have selected is private and cannot be viewed.")
    end


    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @kite }
      format.js { render :template => 'kites/show' }
    end
  end

  # Create a new kite object (will not persist untill passed
  # back to create)
  def new

    @kite = Kite.new

    respond_to do |format|
      format.html { if current_user.ActiveKiteCount >= ARBITRARY_KITE_LIMIT
          redirect_to(Kites, flash[:notice] => 'You cannot create more than #{@@arbitraryKiteLimit} kites.')
        end
      } # new.html.erb
      format.xml  { render :xml => @kite }
    end
  end

  # First step to allowing users to select images from a web source
  def newFromSource

    @kite = Kite.new
    @images = []
    @isAutoAdd = true

    if uri_is_valid?(params[:path])
      site = URI.parse(URI.encode(params[:path]))

      #grab the reference page passed in as parameter
      doc = Nokogiri::HTML(open(site))

      #find all of the images
      doc.css('img').each do |image|
        #debugger
        path = image.attribute('src').value

        if path[0..0] == '/'
          path = URI.join(site, path).to_s
        end
        begin
        dimensions = FastImage.size(path, :timeout => 10.0)
          rescue => ex
            logger.error("Failed to retrieve image dimensions for image: #{ex}")
        end
        if(!dimensions.nil? && dimensions.length > 1 && dimensions[0] > IMAGE_SQUARE_DIMENSION_LIMIT && dimensions[1] > IMAGE_SQUARE_DIMENSION_LIMIT )
          img = {:path => path,
            :source => doc.title,
            :alttext => image.attribute('alt').nil? ? "" : image.attribute('alt').value
          }

          @images << img
        else
          logger.debug "The image #{path} was rejected as under size limit"
        end
      end
    else
      logger.error "The image was rejected as invalid path #{path}"
    end
    @site = site
    if @images.count > 0
      @images[0][:first] = true
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @kite }
    end
  end

  # Retrieve a kite for editing
  def edit
    @kite = Kite.find(params[:id])

    if @kite.UserCanView(current_user) == false
       redirect_to(current_user, :error => "The kite you have selected is private and cannot be viewed.")
     end
  end

  def Join
    @kite = Kite.find(params[:id])
    @userID = params[:follwing][:user_id]

    if(@kite.follwings.empty? || !@kite.follwings.exists?(:user_id => @userID, :Type => "member"))
      @following = Follwing.new
      @following.user_id = @userID
      @following.Type = "member"
      @following.kite = @kite
    else
      @following = @kite.follwings.where(:user_id => @user.id, :Type => "member").first()
    end

    user = User.find(@userID)
    send_kite_update_notification("You have been added as a member of a kite.", @kite, user)

    respond_to do |format|
      if @following && @following.save()
        format.html { redirect_to(@kite, :notice => 'Kite has been followed.')}
        format.xml  { render :xml => @kites, :status => :created, :location => @kites }
        format.js {}
        format.json { render :json => @following, :status => :created}
      else
        format.html { redirect_to(@kite, :notice => 'Could not create following.')}
        format.xml  { render :status => :failure }
        format.js {}
        format.json { render :status => :unprocessable_entity }
      end
    end
  end

  def Unjoin
    @kite = Kite.find(params[:id])
    if(@kite && @kite.follwings.any?)
      @following = @kite.follwings.where(:Type => "member").first
    end

    respond_to do |format|
      if @following && @following.destroy
        format.html { redirect_to(@kite, :notice => 'Kite has been unfollowed.')}
        format.xml  { render :xml => @kite, :status => :created, :location => @kite }
        format.js {}
        format.json { render :json => @following, :status => :success }
      else
        format.html { render :action => "owner_show" }
        format.xml  { render :status => :failure }
        format.js {}
        format.json { render :status => :unprocessable_entity }
      end
    end
  end

  # Add user to list of those following this kite
  def Follow

    @kite = Kite.find(params[:id])

    if(@kite.follwings.empty? || !@kite.follwings.exists?(:user_id => current_user.id, :Type => params[:type]))
      @following = Follwing.new
      @following.user_id = current_user.id
      @following.Type = params[:type]
      @following.kite = @kite
    else
      @following = @kite.follwings.where(:user_id => current_user.id, :Type => params[:type]).first()
    end

    # Let the kite owner know they are loved
    send_kite_update_notification("#{current_user.KosherUsername} has liked your kite", @kite, @kite.user,
      true, true)

    respond_to do |format|
      if @following && @following.save()
        format.html { redirect_to(@kite, :notice => 'Kite has been followed.')}
        format.xml  { render :xml => @kites, :status => :created, :location => @kites }
        format.js {}
        format.json { render :json => @following, :status => :created}
      else
        format.html { render :action => "owner_show" }
        format.xml  { render :status => :failure }
        format.js {}
        format.json { render :status => :unprocessable_entity }
      end
    end

  end

  # Remove a kite following
  def Unfollow

    @kite = Kite.find(params[:id])
    if(@kite && @kite.follwings.any?)
      @following = @kite.follwings.where(:Type => params[:type]).first
    end

    respond_to do |format|
      if @following && @following.destroy
        format.html { redirect_to(@kite, :notice => 'Kite has been unfollowed.')}
        format.xml  { render :xml => @kite, :status => :created, :location => @kite }
        format.js {}
        format.json { render :json => @following, :status => :success }
      else
        format.html { render :action => "owner_show" }
        format.xml  { render :status => :failure }
        format.js {}
        format.json { render :status => :unprocessable_entity }
      end
    end

  end

  # Commit a given kite to the data store
  def create

    if params[:kite].has_key? :ImageLocation
      loc = JSON.parse params[:kite][:ImageLocation]
      params[:kite][:kiteimage] = open(loc['imagePage'], 'rb')
    end

    @kite = Kite.new(params[:kite])
    @kite.CreateDate = Date.today
    @kite.user = current_user
    @kite.Completed = false
    text = @kite.Description + @kite.Details
    if text
      @kite.tag = text.scan(HASHTAG_REGEX).uniq.join(",")
      targetUsers = text.scan(USERTAG_REGEX).uniq
    end

    #Check for at addressing, notify target user
    targetUsers.each do |tu|
      user = User.where(:username => tu.strip[1..-1]).first
    send_kite_update_notification("Someone has mentioned you on their kite.", @kite, user)
    end

    respond_to do |format|
      if @kite.save()
        format.html { redirect_to(@kite, :notice => "Kite was created successfully") }
        format.xml  { render :xml => @kite, :status => :created, :location => @kite }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @kite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Update the parameters of a kite.  Kite and kite id are taken
  # as parameters
  def update
    @kite = Kite.find(params[:id])

    if @kite.UserCanView(current_user) == false
      redirect_to(current_user, :error => "The kite you have selected is private and cannot be viewed.")
    else

      targetUsers = []

      #Need to re-extract tags
      text = @kite.Description + @kite.Details
      if text
        @kite.tag = text.scan(HASHTAG_REGEX).uniq.join(",")
        targetUsers = text.scan(USERTAG_REGEX).uniq
      end

      #Check for at addressing, notify target user
      targetUsers.each do |tu|
        user = User.where(:username => tu.strip[1..-1]).first
        send_kite_update_notification("Someone has mentioned you on their kite.", @kite, user)
      end

      #Let anyone following this kite know as well
      @kite.followers.each do |fol|
        send_kite_update_notification("A kite you are following has been updated.", @kite, fol)
      end

      respond_to do |format|
        if @kite.update_attributes(params[:kite])
          format.html { redirect_to(@kite, :notice => 'Kite was successfully updated.') }
          format.xml  { head :ok }
          format.js {}
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @kite.errors, :status => :unprocessable_entity }
          format.js {}
        end
      end
    end
  end

  def complete

    @kite = Kite.find(params[:id])

    if @kite.user.id == current_user.id
      @kite.complete
    end

    #Let anyone following this kite know as well
    @kite.followers.each do |fol|
      send_kite_update_notification("A kite you are following has been completed!", @kite, fol)
    end

    respond_to do |format|
      format.html { redirect_to(@kite, :notice => 'Congratulations, on completing your kite!') }
      format.xml  { head :ok }
    end
  end

  def promote
    @kite = Kite.find(params[:id])

    if @kite.user.id == current_user.id
      @kite.promote
    end


    respond_to do |format|
      format.html { redirect_to(current_user) }
      format.xml  { head :ok }
    end
  end

  def demote
    @kite = Kite.find(params[:id])

    if @kite.user.id == current_user.id
      @kite.demote
    end

    respond_to do |format|
      format.html { redirect_to(current_user) }
      format.xml  { head :ok }
    end
  end

  # DELETE /kites/1
  # DELETE /kites/1.xml
  def destroy
    @kite = Kite.find(params[:id])

    # Destroy dependent objects
    Comment.where(:kite_id => @kite.id).destroy_all
    Follwing.where(:kite_id => @kite.id).destroy_all
    KitePost.where(:kite_id => @kite.id).destroy_all

    if @kite.user.id == current_user.id
      @kite.destroy
    end

    respond_to do |format|
      format.html { redirect_to(Kite) }
      format.xml  { head :ok }
    end
  end

  def ShareKiteToSocialMedia

    @kite = Kite.find(params[:id])

    #Check that kite is public before continuing...
    if(@kite.sharelevel == "public")

      #check that the user is associated with a facebook profile
      if current_user.provider == "facebook"
        usr = FbGraph::User.me(@kite.user.name)


        fs = usr.feed!(
          :picture => @kite.kiteimage.url(:thumb),
          :link => kite_url(@kite),
          :message => "I've shared a new goal on LifeKite",
          :name => "LifeKite",
          :description => 'Share your goals!'
        )


      end
    end

    respond_to do |format|
      format.html { redirect_to(@kite, :notice => 'Kite was successfully posted.') }
      format.xml  { head :ok }
    end

  end


  private
    def verify_is_admin_or_owner

      if params[:id].nil?
              redirect_to(root_path)
      else
        @kite = Kite.find(params[:id])
        (current_user.nil? || @kite.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.id == 1 || current_user.id == @kite.user.id)
      end
    end

    def verify_is_owner

      if params[:id].nil?
        redirect_to(root_path)
      else
        @kite = Kite.find(params[:id])
        (current_user.nil? || @kite.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.id == @kite.user.id)
      end
    end

    def uri_is_valid?(url)

      url = URI.encode(url)
      uri = URI.parse(url)
      uri.kind_of?(URI::HTTP)
    rescue URI::InvalidURIError
      false
    end

    def get_common_stats
      time_range = (1.week.ago..Time.now)
      @kiteCount = Kite.any? ? Kite.count : 0

       @newKites = Kite.NewKitesCount(time_range)
       @completedKites = Kite.CompletedKitesCount
       @recentComments = Comment.order("created_at DESC").take(3)
       @popularKites = Kite.PopularKites
    end

    def get_personal_stats
      time_range = (1.week.ago..Time.now)
      @kiteCount = current_user.KiteCount
       @newKites = current_user.NewKiteCount(time_range)
       @completedKites = current_user.CompletedKitesCount

       @popularKites = current_user.RecentActivity
    end

    def send_kite_update_notification(message, kite, user, showLikes = false, suppressSelfCheck = false)
      if kite.user != user || suppressSelfCheck
        @notification = Notification.new(
          :message => message,
          :user => user,
          :link => showLikes ? kite_url(kite, :showFollowings => true) : kite_url(kite, :showPosts => true),
          :flavor => "kite")
        if user && kite.user.sendEmailNotifications
          NotificationMailer.notification_email(@notification).deliver
        end
        @notification.save
      end
    end

    def check_and_handle_kites_per_page_update(current_user, params)

      if(current_user && params.include?(:kpp) && current_user.kitesperpage != params[:kpp] && ALLOWABLE_KITES_PER_PAGE.include?(params[:kpp].to_i))
        current_user.kitesperpage = params[:kpp]
        current_user.save
      end

      @kitesPerPage = current_user && current_user.kitesperpage ? current_user.kitesperpage : KITES_PER_PAGE

    end
end
