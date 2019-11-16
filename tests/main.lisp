(defpackage web-test3/tests/main
  (:use :cl
        :web-test3
        :rove))
(in-package :web-test3/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :web-test3)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))

(deftest test-target-2
  (testing "Just test"
    (ok (eq (main) nil))))
