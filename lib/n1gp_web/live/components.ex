defmodule N1gpWeb.Components do
  use Phoenix.Component
  alias N1gpWeb.Router.Helpers, as: Routes

  def two_letters(assigns) do
    assigns = assign_new(assigns, :two_letters, fn ->
      assigns.word
      |> String.split(" ")
      |> case do
        [first] ->
          "#{String.at(first, 0)}#{String.at(first, 1)}"

        [first, second | _rest] ->
          "#{String.at(first, 0)}#{String.at(second, 0)}"

        _ ->
          "?"
      end
    end)

    ~H"""
    <span><%= @two_letters %></span>
    """
  end

  def card(assigns) do
    ~H"""
    <div>
      <h3 class="text-lg font-medium leading-6 text-gray-900"><%= @title %></h3>
      <p class="mt-1 max-w-2xl text-sm text-gray-500"><%= @description %></p>
    </div>
    <div class="mt-5 border-t border-gray-200">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def navicust_description(%{description: "https://" <> rest} = assigns) do
    ~H"""
    <div class="text-center">
      <img src={"https://#{rest}"} class="w-full max-w-[200px] mx-auto h-auto" />
    </div>
    """
  end

  def navicust_description(assigns) do
    ~H"""
    <span><%= @description %></span>
    """
  end

  def tournment_layout(assigns) do
    assigns =
      assigns
      |> assign_new(:filtered_tabs, fn ->
        assigns.tab
        |> Enum.filter(& &1.id == assigns.active_tab)
      end)
      |> assign_new(:progress_pct, fn ->
        completed = Enum.count(assigns.tournment.matches, & &1.state == "complete")
        count = Enum.count(assigns.tournment.matches)

        Float.ceil(100 * completed / count)
      end)

    ~H"""
    <div class="min-h-full">
      <!-- Off-canvas menu for mobile, show/hide based on off-canvas menu state. -->
      <%= if :mobile == false do %>
        <div class="relative z-40 lg:hidden" role="dialog" aria-modal="true">
          <!--
            Off-canvas menu backdrop, show/hide based on off-canvas menu state.

            Entering: "transition-opacity ease-linear duration-300"
              From: "opacity-0"
              To: "opacity-100"
            Leaving: "transition-opacity ease-linear duration-300"
              From: "opacity-100"
              To: "opacity-0"
          -->
          <div class="fixed inset-0 bg-gray-600 bg-opacity-75"></div>

          <div class="fixed inset-0 z-40 flex">
            <!--
              Off-canvas menu, show/hide based on off-canvas menu state.

              Entering: "transition ease-in-out duration-300 transform"
                From: "-translate-x-full"
                To: "translate-x-0"
              Leaving: "transition ease-in-out duration-300 transform"
                From: "translate-x-0"
                To: "-translate-x-full"
            -->
            <div class="relative flex w-full max-w-xs flex-1 flex-col bg-white pt-5 pb-4">
              <!--
                Close button, show/hide based on off-canvas menu state.

                Entering: "ease-in-out duration-300"
                  From: "opacity-0"
                  To: "opacity-100"
                Leaving: "ease-in-out duration-300"
                  From: "opacity-100"
                  To: "opacity-0"
              -->
              <div class="absolute top-0 right-0 -mr-12 pt-2">
                <button type="button" class="ml-1 flex h-10 w-10 items-center justify-center rounded-full focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white">
                  <span class="sr-only">Close sidebar</span>
                  <!-- Heroicon name: outline/x-mark -->
                  <svg class="h-6 w-6 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              </div>

              <div class="flex flex-shrink-0 items-center px-4">
                <img class="h-8 w-auto" src="https://tailwindui.com/img/logos/mark.svg?color=purple&shade=500" alt="Your Company">
              </div>
              <div class="mt-5 h-0 flex-1 overflow-y-auto">
                <nav class="px-2">
                  <div class="space-y-1">
                    <!-- Current: "bg-gray-100 text-gray-900", Default: "text-gray-600 hover:text-gray-900 hover:bg-gray-50" -->
                    <a href="#" class="bg-gray-100 text-gray-900 group flex items-center px-2 py-2 text-base leading-5 font-medium rounded-md" aria-current="page">
                      <!--
                        Heroicon name: outline/home

                        Current: "text-gray-500", Default: "text-gray-400 group-hover:text-gray-500"
                      -->
                      <svg class="text-gray-500 mr-3 flex-shrink-0 h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 12l8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25" />
                      </svg>
                      Home
                    </a>

                    <a href="#" class="text-gray-600 hover:text-gray-900 hover:bg-gray-50 group flex items-center px-2 py-2 text-base leading-5 font-medium rounded-md">
                      <!-- Heroicon name: outline/bars-4 -->
                      <svg class="text-gray-400 group-hover:text-gray-500 mr-3 flex-shrink-0 h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 5.25h16.5m-16.5 4.5h16.5m-16.5 4.5h16.5m-16.5 4.5h16.5" />
                      </svg>
                      My tasks
                    </a>

                    <a href="#" class="text-gray-600 hover:text-gray-900 hover:bg-gray-50 group flex items-center px-2 py-2 text-base leading-5 font-medium rounded-md">
                      <!-- Heroicon name: outline/clock -->
                      <svg class="text-gray-400 group-hover:text-gray-500 mr-3 flex-shrink-0 h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z" />
                      </svg>
                      Recent
                    </a>
                  </div>
                  <div class="mt-8">
                    <h3 class="px-3 text-sm font-medium text-gray-500" id="mobile-teams-headline">Teams</h3>
                    <div class="mt-1 space-y-1" role="group" aria-labelledby="mobile-teams-headline">
                      <a href="#" class="group flex items-center rounded-md px-3 py-2 text-base font-medium leading-5 text-gray-600 hover:bg-gray-50 hover:text-gray-900">
                        <span class="w-2.5 h-2.5 mr-4 bg-indigo-500 rounded-full" aria-hidden="true"></span>
                        <span class="truncate">Engineering</span>
                      </a>

                      <a href="#" class="group flex items-center rounded-md px-3 py-2 text-base font-medium leading-5 text-gray-600 hover:bg-gray-50 hover:text-gray-900">
                        <span class="w-2.5 h-2.5 mr-4 bg-green-500 rounded-full" aria-hidden="true"></span>
                        <span class="truncate">Human Resources</span>
                      </a>

                      <a href="#" class="group flex items-center rounded-md px-3 py-2 text-base font-medium leading-5 text-gray-600 hover:bg-gray-50 hover:text-gray-900">
                        <span class="w-2.5 h-2.5 mr-4 bg-yellow-500 rounded-full" aria-hidden="true"></span>
                        <span class="truncate">Customer Success</span>
                      </a>
                    </div>
                  </div>
                </nav>
              </div>
            </div>

            <div class="w-14 flex-shrink-0" aria-hidden="true">
              <!-- Dummy element to force sidebar to shrink to fit close icon -->
            </div>
          </div>
        </div>
      <% end %>

      <!-- Static sidebar for desktop -->
      <div class="hidden lg:fixed lg:inset-y-0 lg:flex lg:w-64 lg:flex-col lg:border-r lg:border-gray-200 lg:bg-gray-100 lg:pt-5 lg:pb-4">
        <div class="flex flex-shrink-0 items-center px-6">
          <img class="h-8 w-auto" src="https://tailwindui.com/img/logos/mark.svg?color=purple&shade=500" alt="Your Company">
        </div>
        <!-- Sidebar component, swap this element with another sidebar if you like -->
        <div class="mt-6 flex h-0 flex-1 flex-col overflow-y-auto">

          <!-- Navigation -->
          <nav class="mt-6 px-3">
            <div class="space-y-1">
              <%= live_patch to: Routes.tournment_show_path(N1gpWeb.Endpoint, :show, @tournment), class: "bg-gray-200 text-gray-900 group flex items-center px-2 py-2 text-sm font-medium rounded-md" do %>
              <!-- Current: "bg-gray-200 text-gray-900", Default: "text-gray-700 hover:text-gray-900 hover:bg-gray-50" -->
                <!--
                  Heroicon name: outline/home

                  Current: "text-gray-500", Default: "text-gray-400 group-hover:text-gray-500"
                -->
                <svg class="text-gray-500 mr-3 flex-shrink-0 h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 12l8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25" />
                </svg>
                Home
              <% end %>
              <%= live_patch to: Routes.tournment_show_path(N1gpWeb.Endpoint, :stats, @tournment), class: "bg-gray-200 text-gray-900 group flex items-center px-2 py-2 text-sm font-medium rounded-md" do %>
              <!-- Current: "bg-gray-200 text-gray-900", Default: "text-gray-700 hover:text-gray-900 hover:bg-gray-50" -->
                <!--
                  Heroicon name: outline/home

                  Current: "text-gray-500", Default: "text-gray-400 group-hover:text-gray-500"
                -->
                <svg class="text-gray-500 mr-3 flex-shrink-0 h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 12l8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25" />
                </svg>
                Stats
              <% end %>
              <%= live_patch to: Routes.tournment_show_path(N1gpWeb.Endpoint, :most_used_chips, @tournment), class: "bg-gray-200 text-gray-900 group flex items-center px-2 py-2 text-sm font-medium rounded-md" do %>
              <!-- Current: "bg-gray-200 text-gray-900", Default: "text-gray-700 hover:text-gray-900 hover:bg-gray-50" -->
                <!--
                  Heroicon name: outline/home

                  Current: "text-gray-500", Default: "text-gray-400 group-hover:text-gray-500"
                -->
                <svg class="text-gray-500 mr-3 flex-shrink-0 h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 12l8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25" />
                </svg>
                Most used chips
              <% end %>
            </div>
            <div class="mt-8">
              <h3 class="px-3 text-sm font-medium text-gray-500" id="desktop-teams-headline">Progress</h3>
              <div class="mt-1 space-y-1 mb-4" role="group" aria-labelledby="desktop-teams-headline">
                <div class="w-full bg-gray-200 rounded-full h-2.5 dark:bg-gray-700">
                  <div class="bg-blue-600 h-2.5 rounded-full" style={"width: #{@progress_pct}%"}></div>
                </div>
              </div>

              <h3 class="px-3 text-sm font-medium text-gray-500" id="desktop-teams-headline">Tags</h3>
              <div class="mt-1 space-y-1" role="group" aria-labelledby="desktop-teams-headline">
                <a href="#" class="group flex items-center rounded-md px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 hover:text-gray-900">
                  <span class="w-2.5 h-2.5 mr-4 bg-indigo-500 rounded-full" aria-hidden="true"></span>
                  <span class="truncate"><%= @tournment.type %></span>
                </a>
              </div>
            </div>
          </nav>
        </div>
      </div>
      <!-- Main column -->
      <div class="flex flex-col lg:pl-64">
        <!-- Search header -->
        <div class="sticky top-0 z-10 flex h-16 flex-shrink-0 border-b border-gray-200 bg-white lg:hidden">
          <!-- Sidebar toggle, controls the 'sidebarOpen' sidebar state. -->
          <button type="button" class="border-r border-gray-200 px-4 text-gray-500 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-purple-500 lg:hidden">
            <span class="sr-only">Open sidebar</span>
            <!-- Heroicon name: outline/bars-3-center-left -->
            <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
              <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12H12m-8.25 5.25h16.5" />
            </svg>
          </button>
          <div class="flex flex-1 justify-between px-4 sm:px-6 lg:px-8">
            <div class="flex flex-1">
              <form class="flex w-full md:ml-0" action="#" method="GET">
                <label for="search-field" class="sr-only">Search</label>
                <div class="relative w-full text-gray-400 focus-within:text-gray-600">
                  <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center">
                    <!-- Heroicon name: mini/magnifying-glass -->
                    <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                      <path fill-rule="evenodd" d="M9 3.5a5.5 5.5 0 100 11 5.5 5.5 0 000-11zM2 9a7 7 0 1112.452 4.391l3.328 3.329a.75.75 0 11-1.06 1.06l-3.329-3.328A7 7 0 012 9z" clip-rule="evenodd" />
                    </svg>
                  </div>
                  <input id="search-field" name="search-field" class="block h-full w-full border-transparent py-2 pl-8 pr-3 text-gray-900 placeholder-gray-500 focus:border-transparent focus:placeholder-gray-400 focus:outline-none focus:ring-0 sm:text-sm" placeholder="Search" type="search">
                </div>
              </form>
            </div>
            <div class="flex items-center">

            </div>
          </div>
        </div>
        <main class="flex-1">
          <!-- Page title & actions -->
          <div class="border-b border-gray-200 px-4 py-4 sm:flex sm:items-center sm:justify-between sm:px-6 lg:px-8">
            <div class="min-w-0 flex-1">
              <h1 class="text-lg font-medium leading-6 text-gray-900 sm:truncate"><%= @tournment.name %></h1>
            </div>
            <div class="mt-4 flex sm:mt-0 sm:ml-4">
              <button type="button" class="sm:order-0 order-1 ml-3 inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-2 sm:ml-0">Share</button>
              <button type="button" class="order-0 inline-flex items-center rounded-md border border-transparent bg-purple-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-purple-700 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-2 sm:order-1 sm:ml-3">Create</button>
            </div>
          </div>

          <%= render_slot(@filtered_tabs) %>

        </main>
      </div>
    </div>
    """
  end
end
