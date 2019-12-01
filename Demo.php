<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Artisan;
use App\CampaignLesson;
use App\Campaign;
use App\Lesson;
use App\ExamLesson;
use App\Question;
use App\CampaignUser;
use App\PhishPot;

class Demo extends Command
{
  /**
   * The name and signature of the console command.
   *
   * @var string
   */
  protected $signature = 'zisoft:demo {users} {camps} {days}';

  /**
   * The console command description.
   *
   * @var string
   */
  protected $description = 'Command description';

  /**
   * Create a new command instance.
   *
   * @return void
   */
  public function __construct()
  {
    parent::__construct();
  }

  /**
   * Execute the console command.
   *
   * @return mixed
   */
  public function handle()
  {
    $users_count = $this->argument('users');
    $campaign_count = $this->argument('camps');
    $days = $this->argument('days');
    $lesson_per_camp = 5;
    $lesson_count = 8;

    $departments = ['Production', 'R&D', 'Purchasing', 'Marketing', 'HR', 'Accounting', 'Management', 'IT'];
    foreach ($departments as $dtitle) {
      $department = \App\Department::where('title', $dtitle)->first();
      if ($department == null) {
        $department = new \App\Department();
        $department->title = $dtitle;
        $department->save();
      }
    }

    $departments_count = count($departments);

    for ($i = 1; $i <= $users_count; $i++) {
      $username = 'user' . $i;
      $user = \App\User::where('username', $username)->first();
      if ($user == null) {
        $user = new \App\User();
        $user->first_name = 'User';
        $user->last_name = '' . $i;
        $user->username = $username;
        $user->email = $user->username . '@example.com';
        $user->password = bcrypt('Password123@');
        $user->role = 3;
        $user->language = 1;
        $user->source = 1;
        $user->department = ($i % $departments_count) + 1;
        $user->status = 1;
        $user->save();
      }
    }


    Artisan::call('zinad:lessons', [
          'version' => 1,
          'resolution' => '1440',
          'mode' => 'none',
          'campaign1' => 1
    ]);

    $counter = 0;
    for ($k = 1; $k <= $campaign_count; $k++) {
      $title = 'Campaign ' . $k;
      $camp =  Campaign::where('title', $title)->first();
      if ($camp == null) {
        $camp = new \App\Campaign();
        $camp->exam = mt_rand(0, 1) == 1 ? 1 : null;
        $camp->title = $title;
        $camp->player = 'html5';
        $camp->save();
        for ($j = 0; $j < $lesson_per_camp; $j++) {
          $lesson_id = ($counter++ % $lesson_count) + 1;
          $l = Lesson::find($lesson_id);
          $lid = $l->id;
          $questions = Question::where('lesson', $lid)->get();
          $cl = new \App\CampaignLesson();
          $cl->campaign = $camp->id;
          $cl->lesson = $lesson_id;
          $cl->questions = count($questions) > 0 ? 1 : 0;
          $cl->order = 1;
          $cl->save();
        }


        for ($i = 1; $i <= $users_count; $i++) {
          if (mt_rand(0, 1) == 1) {
            $user = \App\User::find($i);
            $user_camp = CampaignUser::where('user', $user->id)->where('campaign', $camp->id)->first();
            if ($user_camp == null) {
              $user_camp = new \App\CampaignUser();
              $user_camp->user = $user->id;
              $user_camp->campaign = $camp->id;
              $user_camp->save();
              $camp = \App\Campaign::find($user_camp->campaign);
              if (isset($camp->exam)) {
                $took = mt_rand(0, 1);
                if ($took) {
                  $passed = mt_rand(0, 1);
                  $e = new \App\UserExam();
                  $e->user = $user->id;
                  $e->campaign = $user_camp->campaign;
                  $e->exam = $camp->exam;
                  $e->result = 100 * $passed;
                  $past = mt_rand(0, $days);
                  $e->created_at = (new \DateTime(date('M d, Y', strtotime("-$past day"))))->format('Y-m-d');
                  $e->save();
                }
              }
              $watched_all = mt_rand(0, 1) == 1;
              $camp_lessons = \App\CampaignLesson::where("campaign", '=', $user_camp->campaign)->get();
              foreach ($camp_lessons as $cl) {
                if ($watched_all || mt_rand(0, 1) == 1) {
                  $w = new \App\WatchedLesson();
                  $w->user = $user->id;
                  $w->campaign = $user_camp->campaign;
                  $w->lesson = $cl->lesson;
                  $past = mt_rand(0, $days);
                  $w->created_at = (new \DateTime(date('M d, Y', strtotime("-$past day"))))->format('Y-m-d');
                  $w->save();

                  if (mt_rand(0, 1) == 1) {
                    $passed = mt_rand(0, 1);
                    $q = new \App\UserQuiz();
                    $q->user = $user->id;
                    $q->campaign = $user_camp->campaign;
                    $q->lesson = $cl->lesson;
                    $q->result = 100 * $passed;
                    $q->created_at = (new \DateTime(date('M d, Y', strtotime("-$past day"))))->format('Y-m-d');
                    $q->save();
                  }
                }
              }
            }
          }
        }
      }
    }

    for ($k = 1; $k <= $campaign_count; $k++) {
      $title = "Campaign $k";
      $pot = PhishPot::where('title', $title)->first();
      if ($pot == null) {
        $pot = new \App\PhishPot();
        $pot->title = $title;
        $pot->page_template = 1;
        $pot->save();

        for ($i = 1; $i <= $users_count; $i++) {
          if (mt_rand(0, 1) == 1) {
            $user = \App\User::find($i);
            $l = new \App\PhishPotLink();
            $l->link = $this->randomLinkGenerator();
            $l->phishpot = $pot->id;
            $l->user = $user->id;
            $past = mt_rand(0, $days);
            if (mt_rand(0, 1) == 1) {
              $l->tracked_at = (new \DateTime(date('M d, Y', strtotime("-$past day"))))->format('Y-m-d');
              if (mt_rand(0, 1) == 1) {
                $l->opened_at = (new \DateTime(date('M d, Y', strtotime("-$past day"))))->format('Y-m-d');
                $l->browser_name = array('Chrome', 'Safary', 'IE', 'Firefox')[mt_rand(0, 3)];
                $l->device_type = array('Mobile', 'Desktop')[mt_rand(0, 1)];
                $l->device_name = array('iOS', 'Windows', 'Mac', 'Linux')[mt_rand(0, 3)];
                if (mt_rand(0, 1) == 1) {
                  $l->submitted_at = (new \DateTime(date('M d, Y', strtotime("-$past day"))))->format('Y-m-d');
                }
              }
            }
            $l->save();
          }
        }
      }
    }
  }

  public function randomLinkGenerator()
  {
    $alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    $pass = array(); //remember to declare $pass as an array
    $alphaLength = strlen($alphabet) - 1; //put the length -1 in cache
    for ($i = 0; $i < 30; $i++) {
      $n = rand(0, $alphaLength);
      $pass[] = $alphabet[$n];
    }
    return implode($pass); //turn the array into a string
  }
}
