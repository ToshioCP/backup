# 保存先のディレクトリ
def dst_dir
  "/media/username/HDDname/backup-#{Time.now.strftime('%F')}"
end

# バックアップをとりたいディレクトリ
def src_dirs
  [
    'ドキュメント',
    'ピクチャ',
  ]
end

# バックアップをとりたいホームディレクトリ直下のファイル
def src_files
  [
    'sample.txt',
    'apple.sh',
    'banana.md',
    'pineapple.pdf',
    'mango.ods',
    'pomelo.xlsx',
    'exercise.mp4'
]
end

# 隠しファイルのうちバックアップを取りたいファイル
def hidden_include
  [
    '.git',
    '.gitignore'
  ]
end
