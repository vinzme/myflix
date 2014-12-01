require 'spec_helper'

describe Category do
  it { should have_many(:video_categories) }
  it { should validate_presence_of(:name) }
end

describe "#recent_videos" do
  it "returns the videos in the reverse chronological order by created at" do
    comedies = Category.create(name: "comedies")
    futurama = Video.create(title: "Futurama", description: "Space Travel!", created_at: 1.day.ago)
    futurama.categories << comedies
    south_park = Video.create(title: "South Park", description: "Crazy kids!")
    south_park.categories << comedies
    expect(comedies.recent_videos).to eq([south_park, futurama])
  end

  it "returns all the videos if there are less than 6 videos" do
    comedies = Category.create(name: "comedies")
    futurama = Video.create(title: "Futurama", description: "Space Travel!", created_at: 1.day.ago)
    futurama.categories << comedies
    south_park = Video.create(title: "South Park", description: "Crazy kids!")
    south_park.categories << comedies
    expect(comedies.recent_videos.count).to eq(2)  
  end

  it "returns 6 videos if there are more than 6 videos" do
    comedies = Category.create(name: "comedies")
    7.times do
      foo = Video.create(title: "Foo", description: "bar")
      foo.categories << comedies
    end
    expect(comedies.recent_videos.count).to eq(6)
  end


  it "returns the most recent 6 videos" do
    comedies = Category.create(name: "comedies")
    6.times do
      foo = Video.create(title: "Foo", description: "bar")
      foo.categories << comedies
    end
    tonight_show = Video.create(title: "Tonight Show", description: "talk show", created_at: 1.day.ago)
    tonight_show.categories << comedies
    expect(comedies.recent_videos).not_to include(tonight_show)
  end


  it "returns an empty array if the category does not have any videos" do
    comedies = Category.create(name: "comedies")
    expect(comedies.recent_videos).to eq([])
  end

end