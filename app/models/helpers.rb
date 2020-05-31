class Helpers
    def self.is_logged_in?(session)
        return false if session[:user_id].nil?
        return true
    end
end