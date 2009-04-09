$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')
FIXTURES_DIR = File.join(File.dirname(__FILE__), "fixtures")
require 'basket'

module BasketFixtures
  def fixtures_name
    "order"
  end

  def fixtures_dir
    FIXTURES_DIR/fixtures_name + "s"
  end

  def create_fixture_files inbox="inbox", howmany=25
    cleanup_fixtures_dir
    inbox_dir = fixtures_dir/inbox
    FileUtils.mkdir_p(inbox_dir)
    0.upto(howmany - 1) do |i|
      filename = inbox_dir/"#{fixtures_name}_%05d" % i
      FileUtils.touch(filename) unless File.exists?(filename)
    end
  end

  def cleanup_fixtures_dir
    FileUtils.rm_rf(fixtures_dir) if File.exists?(fixtures_dir)
  end
end

