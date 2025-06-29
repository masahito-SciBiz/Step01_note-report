#データ内容の確認
##データの読み込み
library(tidyverse)
note_data <- read_csv("step01_note_virtual_data.csv")

##データの構造確認
glimpse(note_data)

##各数値の要約
summary(note_data)

##欠損値の有無
colSums(is.na(note_data))


#前処理
##タイトル文字数
note_data <- note_data %>%
  mutate(title_num = nchar(title))

##スキ率列の追加
note_data <- note_data %>%
  mutate(like_rate = likes / pv)

##タグの分解
library(tidyr)
library(stringr)
note_data_long <- note_data %>%
  separate_rows(tag, sep = ",\\s*") %>%
  mutate(tag = str_trim(tag))

##タグの重複チェック
note_data_long %>%
  count(tag) %>%
  arrange(desc(n))

##時間帯カテゴリの追加
note_data <- note_data %>%
  mutate(
    time_hms = hms::as_hms(paste0(time, ":00")),
    time_hours = hour(time_hms) + minute(time_hms)/60
  )

note_data <- note_data %>%
  mutate(time_category = case_when(
    time_hours < 12 ~ "朝",
    time_hours < 18 ~ "昼",
    TRUE ~ "夜"
  ))

#文字数カテゴリの追加
note_data <- note_data %>%
  mutate(length_category = case_when(
    length < 800 ~ "短文",
    length < 1500 ~ "中文",
    TRUE ~ "長文"
  ))

#文字数カテゴリの可視化
library(showtext)
#Googleフォントorシステムフォントを有効化
showtext_auto()
#フォントサイズを調整したい場合
#theme_set(theme_gray(base_family = ""))


#データ解析
##表にしたいデータ（例：上位10件）
table_data <- head(note_data, 10)

##タイトル文字数と閲覧数の関係
library(gridExtra)
library(grid)
ggplot(note_data, aes(x = title_num, y = pv)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "タイトル文字数と閲覧数の関係", x = "文字数", y = "閲覧数")

##投稿時間と閲覧数の関係
ggplot(note_data, aes(x = time, y = pv)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "投稿時間と閲覧数の関係", x = "投稿時間", y = "閲覧数")

##投稿時間帯と閲覧数の関係
note_data <- note_data %>%
  mutate(time_category = factor(time_category, levels = c("朝", "昼", "夜")))
ggplot(note_data, aes(x = time_category, y = pv)) +
  geom_boxplot() +
  labs(title = "時間帯別の閲覧数(PV)", x = "時間帯", y = "閲覧数")

##文字数と閲覧数の関係
ggplot(note_data, aes(x = length, y = pv)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "文字数と閲覧数の関係", x = "文字数", y = "閲覧数")

##タグ別の平均PV
note_data %>%
  summarise(
    avg_pv = mean(pv)
  )
tag_summary <- note_data_long %>%
  group_by(tag) %>%
  summarise(mean_pv = mean(pv), .groups = "drop")

ggplot(tag_summary, aes(x = reorder(tag, mean_pv), y = mean_pv)) +
  geom_col() +
  coord_flip() +
  labs(title = "タグ別平均閲覧数", x = "タグ", y = "平均PV")

##閲覧数が高い記事の特徴を見る
note_data %>%
  arrange(desc(pv)) %>%
  select(title, title_num, time, length, pv, likes, like_rate) %>%
  head(5)


#エンゲージメント解析
#好きを評価
##PVとスキ数との相関関係
cor(note_data$pv, note_data$likes)

##タイトル文字数とスキ数の関係
ggplot(note_data, aes(x = title_num, y = likes)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "タイトル文字数とスキ数の関係", x = "文字数", y = "スキ数")

##タイトル文字数とスキ率の関係
ggplot(note_data, aes(x = title_num, y = like_rate)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "タイトル文字数とスキ率の関係", x = "文字数", y = "スキ率")

cor(note_data$title_num, note_data$like_rate)

##投稿時間とスキ数の関係
ggplot(note_data, aes(x = time, y = likes)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "投稿時間とスキ数の関係", x = "投稿時間", y = "スキ数")

##投稿時間とスキ率の関係
ggplot(note_data, aes(x = time, y = like_rate)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "投稿時間とスキ率の関係", x = "投稿時間", y = "スキ率")

##投稿時間帯とスキ率の関係
ggplot(note_data, aes(x = time_category, y = like_rate)) +
  geom_boxplot() +
  labs(title = "時間帯別のスキ率", x = "時間帯", y = "スキ率")

#文字数とスキ数の関係
ggplot(note_data, aes(x = length, y = likes)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "文字数とスキ数の関係", x = "文字数", y = "スキ数")

#文字数とスキ率の関係
ggplot(note_data, aes(x = length, y = like_rate)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "文字数とスキ率の関係", x = "文字数", y = "スキ率")

##
tag_summary <- note_data_long %>%
  group_by(tag) %>%
  summarise(mean_like = mean(likes), .groups = "drop")

ggplot(tag_summary, aes(x = reorder(tag, mean_like), y = mean_like)) +
  geom_col() +
  coord_flip() +
  labs(title = "タグ別平均スキ数", x = "タグ", y = "平均スキ数")

##
tag_summary <- note_data_long %>%
  group_by(tag) %>%
  summarise(mean_like_rate = mean(like_rate), .groups = "drop")

ggplot(tag_summary, aes(x = reorder(tag, mean_like_rate), y = mean_like_rate)) +
  geom_col() +
  coord_flip() +
  labs(title = "タグ別平均スキ率", x = "タグ", y = "平均スキ率")

#スキ数が高い記事の特徴を見る
note_data %>%
  arrange(desc(likes)) %>%
  select(title, title_num, time, length, pv, likes, like_rate) %>%
  head(5)

#スキ率が高い記事の特徴を見る
note_data %>%
  arrange(desc(like_rate)) %>%
  select(title, title_num, time, length, pv, likes, like_rate) %>%
  head(5)
