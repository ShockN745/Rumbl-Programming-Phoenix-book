defmodule Rumbl.Router do
  use Rumbl.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Rumbl.Auth, repo: Rumbl.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Note: mix phoenix.routes to see all the available routes of the application
  scope "/", Rumbl do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/users", UserController, only: [:index, :show, :new, :create]
    # Equivalent to:
    # get  "/users",     UserController, :index
    # get  "/users/:id", UserController, :show
    # put  "/users/new", UserController, :new
    # post "/users",     UserController, :create

    resources "/sessions", SessionController, only: [:new, :create, :delete]

    get "/watch/:id", WatchController, :show
  end

  scope "/manage", Rumbl do
    pipe_through [:browser, :authenticate_user]

    resources "/videos", VideoController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Rumbl do
  #   pipe_through :api
  # end
end
