# テーブル設計

## users テーブル

| Column             | Type       | Options                  |
| ------------------ | ---------- | -------------------------|
| nickname           | string     | null: false              |
| email              | string     | null: false,unique: true |
| encrypted_password | string     | null: false              |
| last_name          | string     | null: false              |
| first_name         | string     | null: false              |
| last_name_reading  | string     | null: false              |
| first_name_reading | string     | null: false              |
| birthday           | date       | null: false              |

### Association
- has_many :items
- has_many :orders
- has_many :comments
- has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id'
- has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id'

## items テーブル

| Column             | Type       | Options                        |
| ------------------ | ---------- | -------------------------------|
| item_name          | string     | null: false                    |
| description        | text       | null: false                    |
| category_id        | integer    | null: false                    |
| condition_id       | integer    | null: false                    |
| shipping_charge_id | integer    | null: false                    |
| prefecture_id      | integer    | null: false                    |
| days_to_ship_id    | integer    | null: false                    |
| price              | integer    | null: false                    |
| user               | references | null: false, foreign_key: true |

### Association
- belongs_to :user
- has_one :order
- has_many :comments
- has_many_attached :images
- has_many :notifications

## orders テーブル

| Column   | Type       | Options                        |
| -------- | ---------- | -------------------------------|
| item     | references | null: false, foreign_key: true |
| user     | references | null: false, foreign_key: true |

### Association
- belongs_to :user
- belongs_to :item
- has_one :address

## addresses テーブル

| Column        | Type       | Options                        |
| ------------- | ---------- | -------------------------------|
| postal_cord   | string     | null: false                    |
| prefecture_id | integer    | null: false                    |
| city          | string     | null: false                    |
| house_number  | string     | null: false                    |
| building_name | string     |                                |
| phone_number  | string     | null: false                    |
| order         | references | null: false, foreign_key: true |

### Association
- belongs_to :order

## comments テーブル

| Column   | Type       | Options                        |
| -------- | ---------- | -------------------------------|
| text     | text       | null: false                    |
| item     | integer    | null: false, foreign_key: true |
| user     | integer    | null: false, foreign_key: true |

### Association
- belongs_to :item
- belongs_to :user
- has_many :notifications

## notifications テーブル

| Column       | Type       | Options                     |
| ------------ | ---------- | ----------------------------|
| visitor_id   | integer    | null: false                 |
| visited_id   | integer    | null: false                 |
| item_id      | integer    |                             |
| comment_id   | integer    |                             |
| action       | string     | default: '', null: false    |
| checked      | boolean    | default: false, null: false |

### Association
- belongs_to :item
- belongs_to :comment

- belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id'
- belongs_to :visited, class_name: 'User', foreign_key: 'visited_id'