class AdvertisementsController < ApplicationController

    def index
        @advertisements = Advertisement.all
    end

    def show
    end

    def new
        @advertisement = Advertisement.new
    end

    def create
    end

    def edit
    end

    def update
    end

    def destroy
    end

end
