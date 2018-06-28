# frozen_string_literal: true

class TransportTypesController < ApplicationController
  load_and_authorize_resource
  include InheritAction
end
