export type Course = {
  id: string;
  title: string;
  tagline: string;
  icon: string;
  boss_icon: string;
  boss_name: string;
  boss_sprite: string | null;
  color: string;
  sort_order: number;
};

export type Stage = {
  id: string;
  course_id: string;
  title: string;
  summary: string;
  source_url: string | null;
  source_label: string | null;
  sort_order: number;
};

export type StageProgress = {
  stage_id: string;
  best_score: number;
  read_at: string | null;
  checkpoint_passed: boolean;
};
