# frozen_string_literal: true

# このモジュールには、アプリケーション・ビュー全体で使用できるヘルパー・メソッドが含まれています。
module ApplicationHelper
  # ページごとの完全なタイトルを返す
  # メソッド定義とオプション引数
  def full_title(page_title = '')
    base_title = 'Pro Coach' # 変数への代入
    if page_title.empty?                              # 論理値テスト
      base_title                                      # 暗黙の戻り値
    else
      "#{page_title} | #{base_title}"                 # 文字列の式展開
    end
  end

  def level_text(level)
    case level
    when 'hundred_over'
      'スコア100以上'
    when 'within_hundred'
      'スコア100切り'
    when 'within_ninety'
      'スコア90切り'
    when 'within_eighty_fiv'
      'スコア85切り'
    when 'within_eighty'
      'スコア80切り'
    when 'within_seventy_five'
      'スコア75切り'
    when 'under_par'
      'スコアアンダーパー'
    else
      '未定義'
    end
  end
end
