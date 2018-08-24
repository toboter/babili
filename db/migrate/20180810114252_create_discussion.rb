class CreateDiscussion < ActiveRecord::Migration[5.2]
  def change
    create_table :mentions do |t|
      t.integer     :mentionable_id
      t.string      :mentionable_type
      t.integer     :mentionee_id #namespace
      t.integer     :mentioner_id
      t.timestamps
    end
    add_index :mentions, [:mentionable_id, :mentionable_type]
    add_index :mentions, :mentionee_id
    add_index :mentions, :mentioner_id
  
    create_table :references do |t|
      t.integer     :referencing_id
      t.string      :referencing_type
      t.integer     :referenceable_id
      t.string      :referenceable_type
      t.integer     :referencor_id
      t.timestamps
    end
    add_index :references, [:referencing_id, :referencing_type]
    add_index :references, [:referenceable_id, :referenceable_type]
    add_index :references, :referencor_id

      
    create_table :discussion_assignments do |t|
      t.integer     :thread_id
      t.integer     :assignee_id
      t.integer     :assigner_id
      t.timestamps
    end
    add_index :discussion_assignments, :thread_id
    add_index :discussion_assignments, :assignee_id
    add_index :discussion_assignments, :assigner_id

    create_table :discussion_comments do |t|
      t.integer     :thread_id
      t.integer     :author_id
      t.integer     :versions_count, default: 0
      t.timestamps
    end
    add_index :discussion_comments, :thread_id
    add_index :discussion_comments, :author_id

    create_table :discussion_states do |t|
      t.integer     :thread_id
      t.integer     :setter_id
      t.string      :content, default: 'open'
      t.timestamps
    end
    add_index :discussion_states, :thread_id
    add_index :discussion_states, :setter_id
    add_index :discussion_states, :content

    create_table :discussion_threads do |t|
      t.integer     :discussable_id
      t.string      :discussable_type
      t.integer     :author_id
      t.integer     :sequential_id, null: false
      t.string      :state
      t.integer     :comments_count, default: 0
      t.timestamps
    end
    add_index :discussion_threads, [:discussable_id, :discussable_type]
    add_index :discussion_threads, :author_id
    add_index :discussion_threads, [:sequential_id, :discussable_id, :discussable_type], unique: true, name: 'index_discussion_threads_on_sequential_id_and_discussable'
    add_index :discussion_threads, :state

    create_table :discussion_titles do |t|
      t.integer     :thread_id
      t.integer     :author_id
      t.string      :content
      t.string      :changed_content
      t.timestamps
    end
    add_index :discussion_titles, :thread_id
    add_index :discussion_titles, :author_id

    create_table :discussion_versions do |t|
      t.integer     :comment_id
      t.text        :body
      t.timestamps
    end
    add_index :discussion_versions, :comment_id
  
  end
end
