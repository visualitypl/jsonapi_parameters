require 'rails_helper'

describe 'Stack Tester requests', type: :request do
  describe 'stack_default' do
    it 'fails when exceeding stack limit' do
      payload = select_input_by_name('POST create payloads', 'triple-nested payload')

      payload[:included] << { id: 3, type: 'entity', relationships: { subentity: { data: { type: 'entity', id: 4 } } } }

      post stack_default_path, params: payload

      expect(response).to have_http_status(500)
    end

    it 'passes when stack limit is not exceeded' do
      payload = select_input_by_name('POST create payloads', 'triple-nested payload')

      post stack_default_path, params: payload

      expect(response).to have_http_status(200)
    end
  end

  describe 'stack custom' do
    it 'passes when stack limit is above default' do
      payload = select_input_by_name('POST create payloads', 'triple-nested payload')

      payload[:included] << { id: 3, type: 'entity', relationships: { subentity: { data: { type: 'entity', id: 4 } } } }

      post stack_custom_limit_path, params: payload

      expect(response).to have_http_status(200)
    end

    it 'passes when stack limit is above default using short notation' do
      payload = select_input_by_name('POST create payloads', 'triple-nested payload')

      payload[:included] << { id: 3, type: 'entity', relationships: { subentity: { data: { type: 'entity', id: 4 } } } }

      post short_stack_custom_limit_path, params: payload

      expect(response).to have_http_status(200)
    end
  end
end
