class KakaoController < ApplicationController
  def keyboard
    @keyboard ={
      :type =>"buttons",
      :buttons =>["강아지","로또","메뉴","고양이"]
    }
    render json: @keyboard
  end
  
  def message
    @user_msg = params[:content]
    @text = "기본 텍스트"
    if @user_msg == "로또"
      @text = (1..45).to_a.sample(6).sort.to_s
    elsif @user_msg =="메뉴"
      @text = ["20층","한솥","버거킹"].sample
    elsif @user_msg =="고양이"
      @url = "http://thecatapi.com/api/images/get?format=xml&type=jpg"
      @cat_xml = RestClient.get(@url)
      @cat_doc = Nokogiri::XML(@cat_xml)
      @cat_url = @cat_doc.xpath("//url").text
      @text = @cat_url
    elsif @user_msg =="강아지"
      @url = "https://dog.ceo/api/breeds/image/random"
      @dog_json = RestClient.get(@url)
      @dog_doc =JSON.parse(@dog_json)
      @dog_url = @dog_doc["message"]
      
      
    end
    
    
    @return_msg = {
      :text => @text
    }
    @return_dog = {
      :photo => {
        :url => @dog_url,
        :width => 720,
        :height => 630
      }
    }
    @return_msg_photo = {
      :text => "나만 고양이 없어",
      :photo => {
        :url => @cat_url,
        :width => 720,
        :height => 630
      }
    }
    @return_keyboard = {
      :type =>"buttons",
      :buttons =>["강아지","로또","메뉴","고양이"]
    }
    if @user_msg == "고양이"
      @result = {
        :message => @return_msg_photo,
        :keyboard => @return_keyboard
      }
    elsif @user_msg =="강아지"
       @result = {
        :message => @return_dog,
        :keyboard => @return_keyboard
      }
    else
      @result = {
        :message => @return_msg,
        :keyboard => @return_keyboard
      }
    end
    
    
    
    render json: @result
  end
end
