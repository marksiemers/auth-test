require "./spec_helper"

def user_hash
  {}
end

def user_params
  params = [] of String
  params.join("&")
end

def create_user
  model = User.new(user_hash)
  model.save
  model
end

class UserControllerTest < GarnetSpec::Controller::Test
  getter handler : Amber::Pipe::Pipeline

  def initialize
    @handler = Amber::Pipe::Pipeline.new
    @handler.build :web do
      plug Amber::Pipe::Error.new
      plug Amber::Pipe::Logger.new
      plug Amber::Pipe::Session.new
      plug Amber::Pipe::Flash.new
    end
    @handler.prepare_pipelines
  end
end

describe UserControllerTest do
  subject = UserControllerTest.new

  it "renders user index template" do
    User.clear
    response = subject.get "/users"

    response.status_code.should eq(200)
    response.body.should contain("Users")
  end

  it "renders user show template" do
    User.clear
    model = create_user
    location = "/users/#{model.id}"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Show User")
  end

  it "renders user new template" do
    User.clear
    location = "/users/new"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("New User")
  end

  it "renders user edit template" do
    User.clear
    model = create_user
    location = "/users/#{model.id}/edit"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Edit User")
  end

  it "creates a user" do
    User.clear
    response = subject.post "/users", body: user_params

    response.headers["Location"].should eq "/users"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "updates a user" do
    User.clear
    model = create_user
    response = subject.patch "/users/#{model.id}", body: user_params

    response.headers["Location"].should eq "/users"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "deletes a user" do
    User.clear
    model = create_user
    response = subject.delete "/users/#{model.id}"

    response.headers["Location"].should eq "/users"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end
end
