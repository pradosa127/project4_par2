# defmodule Chat.Worker do
#     use GenServer
#     def start_link()do
#         GenServer.start_link(__MODULE__,[], name: :genMain)
#     end
#     def handle_call({:hello}, _from,[]) do
#         {:reply,"hello",[]}
#     end
# end



defmodule Server do
    use GenServer

  @doc """
  Server Process is started using start_link
  nUsers - total number of users in the twitter system
  followersMap - map of user's id and the follower's list for every user
  displayInterval - the interval in which the tweets are tweeted
  actorsList - contains the process id for every user
  tweetsQueueMap - map of user's id and tweet queue
  searchMap - consists of #hashtags and @users mapped to the tweets that consists them
  maxTweetCount - total number of tweets that has to be tweeted/retweeted before the program is exited
  """

  def init(state) do
      schedule()
      send(self, :zipf)
      {:ok, state}
  end

  def schedule()do
        # Process.send_after(self(), :diplaySimulatorOP, 3000)
  end
  def start_link(nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn) do
    GenServer.start_link(__MODULE__, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn],  name: :gen_main ) 
  end


#   def handle_info(:diplaySimulatorOP, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]) do
#            schedule()
#            time = (:os.system_time(:millisecond) - stTime)
#            tweetsPersecond=((totalTweetCnt-reTweetcnt)/time)*1000
#            reTweetPersecond=(reTweetcnt/time)*1000
#            searchPresecond=(searchCount/time)*1000
#            maximumFollower=Map.get(followersMap,0) |>length()
#            totalRegisterdUser=length(actorsList)
           
#            IO.puts "---------------"
#            IO.puts "User Statisics:"
#            IO.puts "---------------"
#            IO.puts "Total Users            : #{nUsers}"
#            IO.puts "Total registered Users : #{totalRegisterdUser}"
#            IO.puts "Total Online Users     : #{totalRegisterdUser-noOfdisConn}"
#            IO.puts "Maximu subscriber count as per Zipf distibution: #{maximumFollower}"
#            IO.puts " "
#            IO.puts "---------------"
#            IO.puts "Tweet Statisics:"
#            IO.puts "---------------"
#            IO.puts "Total Tweet count   : #{totalTweetCnt}"
#            IO.puts "Tweets persecond    : #{tweetsPersecond}"
#            IO.puts "Total ReTweet count : #{reTweetcnt}"
#            IO.puts "Retweets per second : #{reTweetPersecond}"
#            IO.puts " "
#            IO.puts "---------------"
#            IO.puts "Search Statisics:"
#            IO.puts "---------------"
#            IO.puts "Total Search count                          : #{searchCount}"
#            IO.puts "Searches(Tweets/Hashtag/Mentions) per second: #{searchPresecond}"
#            IO.puts "The time taken by #{nUsers} users is #{time} milliseconds"
#            IO.puts ""
#     {:noreply, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]}
#   end

#   @doc """
#    Update the actors map with (process id, user number) as the (key, value) pair
#   """
#   def handle_cast({:updateActors, pid}, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]) do   
#     {:noreply, [nUsers, followersMap, actorsList++[pid], displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]}
#   end

#   def handle_cast({:updateNoofDisconn, onlineOrOffline}, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]) do   
#       noOfdisConn=if onlineOrOffline==0 do
#         noOfdisConn+1
#       else
#         noOfdisConn-1
#       end
#     {:noreply, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]}
#   end

#   def handle_cast({:updateNoSearch}, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]) do   
#     {:noreply, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount+1,noOfdisConn]}
#   end

#   # # @doc """
#   # #  Get the user PID with the user id from the actors list
#   # # """
#   # def handle_call({:getUserPID, userId}, _from, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]) do
#   #   {:reply, Enum.at(actorsList, userId), [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]}
#   # end

#   @doc """
#    Get the actors list
#   """
#   def handle_call(:getActorsList, _from, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]) do
#     {:reply, actorsList, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]}
#   end

#   @doc """
#    Get the user tweet queue
#   """
#   def handle_call({:getTweetQ, userId}, _from, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]) do
#     {:reply, Map.get(tweetsQueueMap, userId), [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]}
#   end
  

  @doc """
   Update the follower's list 
  """
  # def zipf(nUSers) do
        # s=1.47
        # c=1/(Enum.map(1..nUSers, fn(x)->1/x end)
        #   |>Enum.map(fn(x)-> :math.pow(x,s) end)
        #   |>Enum.sum())

        # zipDist=Enum.map(1..nUSers, fn(x)->c/:math.pow(x,s) end )
        # numFollowers= Enum.map(zipDist, fn(x)->round(Float.ceil((x*nUSers))) end ) 
        # # follwerSet=createfollowerlist([],Enum.at(numFollowers,1),nUSers)
        # for k<- 0..nUSers-1 do
        #     follwerSet=createfollowerlist([],Enum.at(numFollowers,k),nUSers)
        #     GenServer.cast :gen_main,{:updateFollowersMap, follwerSet,k}
        # end
        # IO.puts "update completed"
  # end




  # def handle_cast({:zipf,nUsers},[nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]) do
  #       s=1.47
  #       c=1/(Enum.map(1..nUsers, fn(x)->1/x end)
  #         |>Enum.map(fn(x)-> :math.pow(x,s) end)
  #         |>Enum.sum())

  #       zipDist=Enum.map(1..nUsers, fn(x)->c/:math.pow(x,s) end )
  #       numFollowers= Enum.map(zipDist, fn(x)->round(Float.ceil((x*nUsers))) end ) 
  #       # follwerSet=createfollowerlist([],Enum.at(numFollowers,1),nUSers)
  #       for k<- 0..nUsers-1 do
  #           follwerSet=createfollowerlist([],Enum.at(numFollowers,k),nUsers)
  #           # IO.puts "#{inspect follwerSet}"  
  #           GenServer.cast :gen_main,{:updateFollowersMap, follwerSet,k}
  #       end
  #       IO.puts "update completed"
  #       {:noreply, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]}
  # end

    def createfollowerlist(list,nFollower,nUsers) do
        if nFollower>0 do
          list=list++[:rand.uniform(nUsers)]
          createfollowerlist(list,nFollower-1,nUsers)
        else
          list 
        end    
    end

# # to do -  call inside zipf 
  def handle_cast({:updateFollowersMap, followers,userid}, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]) do
    followersMap = Map.put(followersMap, userid, followers)
    {:noreply, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]}
  end

#  @doc """
#   For extracting hashtags and mentions from the tweets and updating the search map
#  """
  def extractHashTagFromTweets(tweet, searchMap, strArr, i, operation) do
    if i<length(strArr) do
      str  = Enum.at(strArr,i)
      if String.match?(str, ~r/(#).*/) or String.match?(str, ~r/(@).*/) do
        #IO.puts "HashTag/mention #{str}"
        if Map.has_key?(searchMap, str) do
          hashtagSet = Map.get(searchMap, str)
          #IO.inspect tweetQ
          if operation == 1 do
            hashtagSet = if MapSet.size(hashtagSet)<= 100 do
                MapSet.put(hashtagSet, tweet)
            end
          else
            hashtagSet = MapSet.delete(hashtagSet, tweet)
          end
        else
            hashtagSet = MapSet.new()
            hashtagSet =  MapSet.put(hashtagSet, tweet)
        end
        # IO.inspect hashtagSet
        newSearchMap = Map.put(searchMap, str, hashtagSet)
        extractHashTagFromTweets(tweet, newSearchMap, strArr, i+1, operation)
      end
    else
      #IO.inspect searchMap
      searchMap
    end
  end


#  @doc """
#   For updating hashtags and mentions in the searchMap
#  """
  def handle_cast({:updateSearchMap, tweet, operation}, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]) do
    strArr = String.split(tweet, " ")
    if operation == 1 do
      newSearchMap = extractHashTagFromTweets(tweet, searchMap, strArr, 0, 1)
    else
      newSearchMap = extractHashTagFromTweets(tweet, searchMap, strArr, 0, 0)
    end
    # IO.inspect newSearchMap
    {:noreply, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, newSearchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]}
  end


  def handle_cast({:updateNoofdisconn, connstate}, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]) do
    if connstate == 0 do
      noOfdisConn = noOfdisConn+1
    else
      noOfdisConn = noOfdisConn-1
    end
    # IO.puts "#{noOfdisConn}"
    {:noreply, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]}
  end

#  @doc """
#   For searching tweets with specific hashtags and mentions
#  """
  def handle_call({:searchHashTag, hashTagOrMention}, _from, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]) do
    #hashTagOrMention = "#HashTag1"
    if Map.has_key?(searchMap, hashTagOrMention) do
      tweetSet = Map.get(searchMap, hashTagOrMention)
    else
      tweetSet = MapSet.new()
    end
    # IO.puts "Result of searching for #{hashTagOrMention}"
    # IO.inspect tweetSet
    {:reply, tweetSet, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount+1,noOfdisConn]}
  end
    

  def handle_call({:diplaySimulatorOP}, _from, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]) do
    {:reply, {totalTweetCnt,reTweetcnt,searchCount,noOfdisConn}, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]}
  end 
  
 @doc """
  When a user  tweets :tweet updates the users's and it's followers tweet queue
 """
  def handle_cast({:tweet, tweet, userId, tweetOrPopulate}, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]) do
      # IO.puts "User#{userId} tweeting #{tweet}"
      if Map.has_key?(tweetsQueueMap, userId) do
        tweetQ = Map.get(tweetsQueueMap, userId)
        # IO.inspect tweetQ
        if :queue.len(tweetQ)> 100 do
          tweetQ = :queue.in(tweet, :queue.drop(tweetQ))
            #remove tweet from Search Map
          GenServer.cast :gen_main, {:updateSearchMap, tweet, 0}
        else
          :queue.in(tweet, tweetQ)
          # IO.inspect tweet
        end
      else
        tweetQ = :queue.new
        tweetQ = :queue.in(tweet, tweetQ)
      end
      # IO.inspect tweetQ
      if(tweetQ==nil)do
        IO.puts "dfvn,nmvkdfnvmbk/ndfb"
        System.halt(0)
      end
      
      new_tweetsQueueMap = Map.put(tweetsQueueMap, userId, tweetQ)
      # IO.inspect new_tweetsQueueMap
    #   # if Map.get(new_tweetsQueueMap, userId)== nil do
    #   #   IO.inspect userId
    #   #   IO.inspect new_tweetsQueueMap
    #   #   IO.inspect Map.get(tweetsQueueMap, userId)
    #   #   IO.puts "mldsclsjcmasvkdjfvm/kvjfioefkvjwivrwtip'sbrtg'ibrt'btr"
    #   #   System.halt(0)
    #   # end
    #   userPID = Enum.at(actorsList, userId) 
    #   GenServer.cast userPID, {:receiveTweet, tweet}

      # update searchMap and follower's tweet queues
      if tweetOrPopulate == "tweet" do
      #   #add tweet from Search Map
        GenServer.cast :gen_main, {:updateSearchMap, tweet, 1}
        # userFollowersList = Map.get(followersMap, userId)
        # GenServer.cast :gen_main, {:updateFollowersTweetQ, userFollowersList, 0, tweet}
      end
      
    totalTweetCnt=totalTweetCnt+1

      # if(Integer.mod(totalTweetCnt,100000)==0)do
      #      time = (:os.system_time(:millisecond) - stTime)
      #      tweetsPersecond=((totalTweetCnt-reTweetcnt)/time)*1000
      #      reTweetPersecond=(reTweetcnt/time)*1000
      #      searchPresecond=(searchCount/time)*1000
      #      IO.puts "total tweet handled by server persecond: #{tweetsPersecond}"
      #      IO.puts "total retweet handled by server per second: #{reTweetPersecond}"
      #      IO.puts "total Searches handled by server per second: #{searchCount}"
      #      IO.puts "total live connecteions: #{nUsers-noOfdisConn}"
      #      IO.puts "The time taken by #{nUsers} users is #{time} milliseconds"
      #      IO.puts ""
      # end
     
      {:noreply, [nUsers, followersMap, actorsList, displayInterval, new_tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]}
  end



  def handle_info(:zipf, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]) do
    s=1.47
    c=1/(Enum.map(1..nUsers, fn(x)->1/x end)
      |>Enum.map(fn(x)-> :math.pow(x,s) end)
      |>Enum.sum())

    zipDist=Enum.map(1..nUsers, fn(x)->c/:math.pow(x,s) end )
    numFollowers= Enum.map(zipDist, fn(x)->round(Float.ceil((x*nUsers))) end ) 
    # follwerSet=createfollowerlist([],Enum.at(numFollowers,1),nUSers)
    for k<- 0..nUsers-1 do
        follwerSet=createfollowerlist([],Enum.at(numFollowers,k),nUsers)
        # IO.puts "#{inspect follwerSet}"  
        GenServer.cast :gen_main,{:updateFollowersMap, follwerSet,k}
    end
    IO.puts "update completed"
   
    {:noreply, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]}
  end

#   def handle_cast({:updateFollowersTweetQ, userFollowersList, i, tweet}, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]) do
#     if i < length(userFollowersList) do 
#       k = Enum.at(userFollowersList, i)
#       userPID = Enum.at(actorsList, k)
#       GenServer.cast :gen_main, {:tweet, tweet, k, "populate"}
#       GenServer.cast :gen_main, {:updateFollowersTweetQ, userFollowersList, i+1, tweet}
#     end
#     {:noreply, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]}
#   end

#   #check if this is required
#   def handle_call({:getUserFollowers, userId}, _from, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]) do
#     {:reply, length(Map.get(followersMap, userId)), [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt+1, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]}
#   end 


#   @doc """
#   For retweeting the tweets
#   """
#   def handle_cast({:retweet, tweet, userId}, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]) do
#     GenServer.cast :gen_main, {:tweet, tweet, userId, "tweet"}
#     # IO.puts "User#{userId} retweeting"
#     {:noreply, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt+1,searchCount,noOfdisConn]}
#   end

#   def handle_call(:getFollowers, _from, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]) do
#     {:reply, followersMap, [nUsers, followersMap, actorsList, displayInterval, tweetsQueueMap, searchMap, totalTweetCnt+1, maxTweetCnt, stTime,reTweetcnt,searchCount,noOfdisConn]}
#   end 
end
