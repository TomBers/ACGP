defmodule AcgpWeb.Router do
  use AcgpWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AcgpWeb do
    pipe_through :browser

    live "/askhole/:id", AskHole, layout: {AcgpWeb.LayoutView, :app}
    live "/mml/:id", MakeMeLaugh, layout: {AcgpWeb.LayoutView, :app}
    live "/drawit/:id", DrawIt, layout: {AcgpWeb.LayoutView, :app}
    live "/aw/:id", AnswerWrong, layout: {AcgpWeb.LayoutView, :app}
    live "/wtn/:id", WhatTheName, layout: {AcgpWeb.LayoutView, :app}
    live "/picit/:id", PictureIt, layout: {AcgpWeb.LayoutView, :app}
    live "/abundance/:id", Abundance, layout: {AcgpWeb.LayoutView, :app}

    get "/", PageController, :index
    get "/askhole", PageController, :askhole
    get "/mml", PageController, :mml
    get "/drawit", PageController, :drawit
    get "/aw", PageController, :answerwrong
    get "/wtn", PageController, :whatthename
    get "/picit", PageController, :picit
    get "/abundance", PageController, :abundance
  end

  # Other scopes may use custom stacks.
  # scope "/api", AcgpWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: AcgpWeb.Telemetry
    end
  end
end
