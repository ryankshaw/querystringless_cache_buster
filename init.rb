

if ENV["RAILS_USE_QUERYSTRINGLESS_CACHE_BUSTER"]
  
  unless ENV["RAILS_ASSET_ID"]
    require 'find'
    sizes = []
    Find.find('public/') do |f| 
      sizes << File.mtime(f).to_i  
    end
    ENV["RAILS_ASSET_ID"] = sizes.max.to_s
  end
  
  ActionView::Helpers::AssetTagHelper.class_eval do 
    def rewrite_asset_path(source)
      if ENV["RAILS_ASSET_ID"]
        "/" + ENV["RAILS_ASSET_ID"] + source
      else
        asset_id = rails_asset_id(source)
        if asset_id.blank?
          source
        else
          source + "?#{asset_id}"
        end
      end
    end
  end
end

