require 'taglib'

class Tagger
  def self.tag(mp3,tags)
    TagLib::MPEG::File.open(mp3) do |f|
      t = f.id3v2_tag || TagLib::ID3v2::Tag.new
      if tags[:title]
        t.title = tags[:title]
      end
      if tags[:artist]
        t.artist = tags[:artist]
      end
      if tags[:album]
        t.album = tags[:album]
      end
      if tags[:year]
        t.year = tags[:year].to_i
      end
      if tags[:picture]
        if !t.frame_list('APIC').first
          cover = TagLib::ID3v2::AttachedPictureFrame.new
          cover.type = TagLib::ID3v2::AttachedPictureFrame::FrontCover
          cover.picture = File.open((File.expand_path(tags[:picture])),"rb"){|f|f.read}
          t.add_frame(cover)
        else
          cover = t.frame_list('APIC').first
          cover.type = TagLib::ID3v2::AttachedPictureFrame::FrontCover
          cover.picture = File.open((File.expand_path(tags[:picture])),"rb"){|f|f.read}
          t.add_frame(cover)
        end
      end
      f.save
    end
  end

  # clear all tags
  def self.clear(mp3)
    TagLib::MPEG::File.open(mp3) do |f|
      tag = f.id3v2_tag
      if tag
        tag.remove_frames('TPE1')
      end
      f.save
    end
  end

  def self.print_tags(mp3)
    TagLib::MPEG::File.open(mp3) do |f|
      t = f.id3v2_tag

      puts "title: #{t.title}"
      puts "artist: #{t.artist}"
      puts "album: #{t.album}"
      puts "year: #{t.year}"

      cover = t.frame_list('APIC').first
      puts "image: [#{cover.mime_type}] [#{cover.picture.length} bytes]"
    end
  end
end
