# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'GET /foos with SORTING', type: :request do
  let!(:foo) { FactoryGirl.create(:foo) }
  let!(:others) { FactoryGirl.create_list(:foo, 2) }
  let(:results) { JSON.parse(response.body) }
  let(:results_ids) { results.map { |f| f['id'] } }

  before(:each) do
    get foos_path, params: params, headers: {}
  end

  context 'with a :string attribute type' do
    context 'on the base object' do
      let(:params) do
        { sort: sort_param }
      end

      context 'when direction is ASC' do
        let(:direction) { :asc }

        context 'with default case-sensitive sort' do
          let(:sort_param) { { 'string': direction } }
          let(:expected_ids) do
            Foo.order(string: direction)
               .pluck(:id)
          end

          it { expect(response).to have_http_status :ok }
          it { expect(results_ids).to eq expected_ids }
        end

        context 'with case-INsensitive sort' do
          let(:sort_param) { { 'string(i)': direction } }
          let(:expected_ids) do
            Foo.order("LOWER(string) #{direction}")
               .pluck(:id)
          end

          it { expect(response).to have_http_status :ok }
          it { expect(results_ids).to eq expected_ids }
        end
      end

      context 'when direction is DESC' do
        let(:direction) { :desc }

        context 'with default case-sensitive sort' do
          let(:sort_param) { { 'string': direction } }
          let(:expected_ids) do
            Foo.order(string: direction)
               .pluck(:id)
          end

          it { expect(response).to have_http_status :ok }
          it { expect(results_ids).to eq expected_ids }
        end

        context 'with case-INsensitive sort' do
          let(:sort_param) { { 'string(i)': direction } }
          let(:expected_ids) do
            Foo.order("LOWER(string) #{direction}")
               .pluck(:id)
          end

          it { expect(response).to have_http_status :ok }
          it { expect(results_ids).to eq expected_ids }
        end
      end
    end

    context 'on an associated object' do
      let(:params) do
        { sort: { assoc: sort_param } }
      end

      context 'when direction is ASC' do
        let(:direction) { :asc }

        context 'with default case-sensitive sort' do
          let(:sort_param) { { 'string': direction } }
          let(:expected_ids) do
            Foo.joins(:assoc)
               .merge(Assoc.order(string: direction))
               .pluck(:id)
          end

          it { expect(response).to have_http_status :ok }
          it { expect(results_ids).to eq expected_ids }
        end

        context 'with case-INsensitive sort' do
          let(:sort_param) { { 'string(i)': direction } }
          let(:expected_ids) do
            Foo.joins(:assoc)
               .merge(Assoc.order("LOWER(#{Assoc.table_name}.string) #{direction}"))
               .pluck(:id)
          end

          it { expect(response).to have_http_status :ok }
          it { expect(results_ids).to eq expected_ids }
        end
      end

      context 'when direction is DESC' do
        let(:direction) { :desc }

        context 'with default case-sensitive sort' do
          let(:sort_param) { { 'string': direction } }
          let(:expected_ids) do
            Foo.joins(:assoc)
               .merge(Assoc.order(string: direction))
               .pluck(:id)
          end

          it { expect(response).to have_http_status :ok }
          it { expect(results_ids).to eq expected_ids }
        end

        context 'with case-INsensitive sort' do
          let(:sort_param) { { 'string(i)': direction } }
          let(:expected_ids) do
            Foo.joins(:assoc)
               .merge(Assoc.order("LOWER(#{Assoc.table_name}.string) #{direction}"))
               .pluck(:id)
          end

          it { expect(response).to have_http_status :ok }
          it { expect(results_ids).to eq expected_ids }
        end
      end
    end
  end
end
