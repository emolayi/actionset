# frozen_string_literal: true

require_relative './page_size_for_helper'

module Pagination
  module TotalPagesForHelper
    include Pagination::PageSizeForHelper

    def pagination_total_pages_for(set)
      total_set_size = set.set.count

      (total_set_size.to_f / pagination_page_size_for(set)).ceil
    end
  end
end