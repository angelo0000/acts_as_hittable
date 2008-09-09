class Hit < ActiveRecord::Base
  belongs_to :hittable, :polymorphic => true
end

module OmegaPrime
  module HitTracker
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_hittable
        has_many :hits, :as => :hittable, :dependent => :destroy
        include OmegaPrime::HitTracker::InstanceMethods
      end
    end

    module InstanceMethods
      def hit_count
        return self.hits.size
      end

      def hit
        self.hits.create
      end
    end
  
    module ControllerMethods
      def hit(objects)
        Array(objects).each do |obj|
          obj.hits.create
        end
      end
    end
  end
end

ActiveRecord::Base.class_eval do
  include OmegaPrime::HitTracker
end

ActionController::Base.class_eval do
  include OmegaPrime::HitTracker::ControllerMethods
end