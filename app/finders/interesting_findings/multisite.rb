module WPScan
  module Finders
    module InterestingFindings
      # Multisite checker
      class Multisite < CMSScanner::Finders::Finder
        # @return [ InterestingFinding ]
        def aggressive(_opts = {})
          url      = target.url('wp-signup.php')
          res      = Browser.get(url)
          location = res.headers_hash['location']

          return unless [200, 302].include?(res.code)
          return if res.code == 302 && location =~ /wp-login\.php\?action=register/
          return unless res.code == 200 || res.code == 302 && location =~ /wp-signup\.php/

          target.multisite = true

          WPScan::InterestingFinding.new(
            url,
            confidence: 100,
            found_by: DIRECT_ACCESS,
            to_s: 'This site seems to be a multisite',
            references: %w(http://codex.wordpress.org/Glossary#Multisite)
          )
        end
      end
    end
  end
end
