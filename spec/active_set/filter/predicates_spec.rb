# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveSet do
  before(:all) do
    @thing_1 = FactoryBot.create(:thing)
    @thing_2 = FactoryBot.create(:thing)
  end

  describe '#filter' do
    ['itself', 'to_a'].each do |relation_mutator|
      context "/#{ relation_mutator == 'itself' ? 'ActiveRecord' : 'Enumberable' }/" do
        before(:all) do
          @active_set = ActiveSet.new(Thing.all.public_send(relation_mutator))
        end
        let(:results) { @active_set.filter(instructions) }
        let(:result_ids) { results.map(&:id) }

        ApplicationRecord::DB_FIELD_TYPES.each do |type|
          [1, 2].each do |id|
            INCLUSIVE_UNARY_OPERATORS.each do |operator|
              %W[
                #{type}(#{operator})
                only.#{type}(#{operator})
              ].each do |path|
                context "{ #{path}: }" do
                  let(:matching_item) { instance_variable_get("@thing_#{id}") }
                  let(:instruction_single_value) do
                    value_for(object: matching_item, path: path)
                  end
                  let(:instructions) do
                    {
                      path => instruction_single_value
                    }
                  end

                  it { expect(result_ids).to include matching_item.id }
                end
              end
            end

            EXCLUSIVE_UNARY_OPERATORS.each do |operator|
              %W[
                #{type}(#{operator})
                only.#{type}(#{operator})
              ].each do |path|
                context "{ #{path}: }" do
                  let(:matching_item) { instance_variable_get("@thing_#{id}") }
                  let(:instruction_single_value) do
                    value_for(object: matching_item, path: path)
                  end
                  let(:instructions) do
                    {
                      path => instruction_single_value
                    }
                  end

                  it { expect(result_ids).not_to include matching_item.id }
                end
              end
            end

            INCLUSIVE_BINARY_OPERATORS.each do |operator|
              %W[
                #{type}(#{operator})
                only.#{type}(#{operator})
              ].each do |path|
                context "{ #{path}: }" do
                  let(:matching_item) { instance_variable_get("@thing_#{id}") }
                  let(:other_thing) do
                    guaranteed_unique_object_for(matching_item,
                                                 only: guaranteed_unique_object_for(matching_item.only))
                  end
                  let(:matching_value) { value_for(object: matching_item, path: path) }
                  let(:other_value) { value_for(object: other_thing, path: path) }
                  let(:instruction_multi_value) do
                    if operator.to_s.include? 'IN_'
                      [ [matching_value], [other_value] ]
                    else
                      [ matching_value, other_value ]
                    end
                  end
                  let(:instructions) do
                    { path => instruction_multi_value }
                  end

                  it { expect(result_ids).to include matching_item.id }
                end
              end
            end

            EXCLUSIVE_BINARY_OPERATORS.each do |operator|
              %W[
                #{type}(#{operator})
                only.#{type}(#{operator})
              ].each do |path|
                context "{ #{path}: }" do
                  let(:matching_item) { instance_variable_get("@thing_#{id}") }
                  let(:other_thing) do
                    guaranteed_unique_object_for(matching_item,
                                                 only: guaranteed_unique_object_for(matching_item.only))
                  end
                  let(:matching_value) { value_for(object: matching_item, path: path) }
                  let(:other_value) { value_for(object: other_thing, path: path) }
                  let(:instruction_multi_value) do
                    if operator.to_s.include? 'IN_'
                      [ [matching_value], [other_value] ]
                    else
                      [ matching_value, other_value ]
                    end
                  end
                  let(:instructions) do
                    { path => instruction_multi_value }
                  end

                  it { expect(result_ids).not_to include matching_item.id }
                end
              end
            end

            INCONCLUSIVE_BINARY_OPERATORS.each do |operator|
              %W[
                #{type}(#{operator})
                only.#{type}(#{operator})
              ].each do |path|
                context "{ #{path}: }" do
                  let(:matching_item) { instance_variable_get("@thing_#{id}") }
                  let(:other_thing) do
                    FactoryBot.build(:thing,
                                     boolean: !matching_item.boolean,
                                     only: FactoryBot.build(:only,
                                                            boolean: !matching_item.only.boolean))
                  end
                  let(:instruction_multi_value) do
                    [
                      value_for(object: matching_item, path: path),
                      value_for(object: other_thing, path: path)
                    ]
                  end
                  let(:instructions) do
                    {
                      path => instruction_multi_value
                    }
                  end

                  # By default, we expect these operators to return nothing.
                  # If, however, they do return something, we guarantee it is a logical result
                  it do
                    set_instruction = ActiveSet::Filtering::Enumerable::SetInstruction
                      .new(
                        ActiveSet::AttributeInstruction.new(path, instruction_multi_value),
                        @active_set.set)

                    expect(results.map { |obj| set_instruction.item_matches_query?(obj) }).to all( be true )
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
