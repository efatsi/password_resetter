module Dummy
  module VoteConnector
        
    extend ActiveSupport::Concern

    def create_vote_by(user, direction)
      self.points += (direction == "up" ? 1 : -1)
      self.save
      Vote.create(:user_id => user.id, :votable  => self, :direction => direction)
    end
    
    module ClassMethods
      def voted_on_by(user)
        self.joins("LEFT OUTER JOIN votes ON votes.votable_id = #{self.table_name}.id AND votes.votable_type = '#{self.to_s}'").where("votes.user_id = #{user.id}")
      end

      def upvoted_by(user)
        self.joins("LEFT OUTER JOIN votes ON votes.votable_id = #{self.table_name}.id AND votes.votable_type = '#{self.to_s}'").where("votes.user_id = ? AND votes.direction = 'up'", user.id)
      end
    end

  end
end


