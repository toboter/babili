# Listen gehören zu einem Namespace und haben einen Ersteller. Durch Namespace wird durch accessors 
# auf sie Zugriff gegeben. Listen haben 0..n ListenElemente. Diese ListenElemente binden 
# als interestable polymorphisch an Biblio:Entry oder Aggregation::Item::Commit, aber auch an 
# CMS::Content, Zensus::Agent, Locate::Place, Vocab::Concept an.
# Listen können in ein Repo überführt werden. Nicht importierbare Elemente werden 
# in den Repos dann als favs angezeigt.
# Listen können vervielfältigt werden.

# namespace_id:integer
# public:boolean
# name:string
# description:text (-> als TrixEditor)
# copied_from_id:integer
# creator_id:integer
# forked_to_repo_id:integer
# forked_at:datetime
# elements_count