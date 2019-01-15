require 'rails_helper'

describe PongController, type: :controller do
  it 'returns pong' do
    get :pong

    expect(response.code).to eq('200')
  end
end
