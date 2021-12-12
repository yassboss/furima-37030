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
- has_many :purchases


## items テーブル

| Column          | Type       | Options                        |
| --------------- | ---------- | -------------------------------|
| item_name       | string     | null: false                    |
| description     | text       | null: false                    |
| category        | integer    | null: false                    |
| condition       | integer    | null: false                    |
| shipping_charge | integer    | null: false                    |
| shipment_area   | integer    | null: false                    |
| days_to_ship    | integer    | null: false                    |
| price           | integer    | null: false                    |
| status          | string     | null: false                    |
| user            | references | null: false, foreign_key: true |

### Association
- belongs_to :user
- has_one :order

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

| Column       | Type       | Options                        |
| ------------ | ---------- | -------------------------------|
| postal_cord  | string     | null: false                    |
| prefecture   | integer    | null: false                    |
| city         | string     | null: false                    |
| house_number | string     | null: false                    |
| phone_number | string     | null: false                    |
| order        | references | null: false, foreign_key: true |

### Association
- belongs_to :order