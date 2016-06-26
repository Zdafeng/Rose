! Fast Fourier/Cosine/Sine Transform
!     dimension   :one
!     data length :power of 2
!     decimation  :frequency
!     radix       :8, 4, 2
!     data        :inplace
!     table       :use
! subroutines
!     cdft: Complex Discrete Fourier Transform
!     rdft: Real Discrete Fourier Transform
!     ddct: Discrete Cosine Transform
!     ddst: Discrete Sine Transform
!     dfct: Cosine Transform of RDFT (Real Symmetric DFT)
!     dfst: Sine Transform of RDFT (Real Anti-symmetric DFT)
!
!
! -------- Complex DFT (Discrete Fourier Transform) --------
!     [definition]
!         <case1>
!             X(k) = sum_j=0^n-1 x(j)*exp(2*pi*i*j*k/n), 0<=k<n
!         <case2>
!             X(k) = sum_j=0^n-1 x(j)*exp(-2*pi*i*j*k/n), 0<=k<n
!         (notes: sum_j=0^n-1 is a summation from j=0 to n-1)
!     [usage]
!         <case1>
!             ip(0) = 0  ! first time only
!             call cdft(2*n, 1, a, ip, w)
!         <case2>
!             ip(0) = 0  ! first time only
!             call cdft(2*n, -1, a, ip, w)
!     [parameters]
!         2*n          :data length (integer)
!                       n >= 1, n = power of 2
!         a(0:2*n-1)   :input/output data (real*8)
!                       input data
!                           a(2*j) = Re(x(j)), 
!                           a(2*j+1) = Im(x(j)), 0<=j<n
!                       output data
!                           a(2*k) = Re(X(k)), 
!                           a(2*k+1) = Im(X(k)), 0<=k<n
!         ip(0:*)      :work area for bit reversal (integer)
!                       length of ip >= 2+sqrt(n)
!                       strictly, 
!                       length of ip >= 
!                           2+2**(int(log(n+0.5)/log(2.0))/2).
!                       ip(0),ip(1) are pointers of the cos/sin table.
!         w(0:n/2-1)   :cos/sin table (real*8)
!                       w(),ip() are initialized if ip(0) = 0.
!     [remark]
!         Inverse of 
!             call cdft(2*n, -1, a, ip, w)
!         is 
!             call cdft(2*n, 1, a, ip, w)
!             do j = 0, 2 * n - 1
!                 a(j) = a(j) / n
!             end do
!         .
!
!
! -------- Real DFT / Inverse of Real DFT --------
!     [definition]
!         <case1> RDFT
!             R(k) = sum_j=0^n-1 a(j)*cos(2*pi*j*k/n), 0<=k<=n/2
!             I(k) = sum_j=0^n-1 a(j)*sin(2*pi*j*k/n), 0<k<n/2
!         <case2> IRDFT (excluding scale)
!             a(k) = (R(0) + R(n/2)*cos(pi*k))/2 + 
!                    sum_j=1^n/2-1 R(j)*cos(2*pi*j*k/n) + 
!                    sum_j=1^n/2-1 I(j)*sin(2*pi*j*k/n), 0<=k<n
!     [usage]
!         <case1>
!             ip(0) = 0  ! first time only
!             call rdft(n, 1, a, ip, w)
!         <case2>
!             ip(0) = 0  ! first time only
!             call rdft(n, -1, a, ip, w)
!     [parameters]
!         n            :data length (integer)
!                       n >= 2, n = power of 2
!         a(0:n-1)     :input/output data (real*8)
!                       <case1>
!                           output data
!                               a(2*k) = R(k), 0<=k<n/2
!                               a(2*k+1) = I(k), 0<k<n/2
!                               a(1) = R(n/2)
!                       <case2>
!                           input data
!                               a(2*j) = R(j), 0<=j<n/2
!                               a(2*j+1) = I(j), 0<j<n/2
!                               a(1) = R(n/2)
!         ip(0:*)      :work area for bit reversal (integer)
!                       length of ip >= 2+sqrt(n/2)
!                       strictly, 
!                       length of ip >= 
!                           2+2**(int(log(n/2+0.5)/log(2.0))/2).
!                       ip(0),ip(1) are pointers of the cos/sin table.
!         w(0:n/2-1)   :cos/sin table (real*8)
!                       w(),ip() are initialized if ip(0) = 0.
!     [remark]
!         Inverse of 
!             call rdft(n, 1, a, ip, w)
!         is 
!             call rdft(n, -1, a, ip, w)
!             do j = 0, n - 1
!                 a(j) = a(j) * 2 / n
!             end do
!         .
!
!
! -------- DCT (Discrete Cosine Transform) / Inverse of DCT --------
!     [definition]
!         <case1> IDCT (excluding scale)
!             C(k) = sum_j=0^n-1 a(j)*cos(pi*j*(k+1/2)/n), 0<=k<n
!         <case2> DCT
!             C(k) = sum_j=0^n-1 a(j)*cos(pi*(j+1/2)*k/n), 0<=k<n
!     [usage]
!         <case1>
!             ip(0) = 0  ! first time only
!             call ddct(n, 1, a, ip, w)
!         <case2>
!             ip(0) = 0  ! first time only
!             call ddct(n, -1, a, ip, w)
!     [parameters]
!         n            :data length (integer)
!                       n >= 2, n = power of 2
!         a(0:n-1)     :input/output data (real*8)
!                       output data
!                           a(k) = C(k), 0<=k<n
!         ip(0:*)      :work area for bit reversal (integer)
!                       length of ip >= 2+sqrt(n/2)
!                       strictly, 
!                       length of ip >= 
!                           2+2**(int(log(n/2+0.5)/log(2.0))/2).
!                       ip(0),ip(1) are pointers of the cos/sin table.
!         w(0:n*5/4-1) :cos/sin table (real*8)
!                       w(),ip() are initialized if ip(0) = 0.
!     [remark]
!         Inverse of 
!             call ddct(n, -1, a, ip, w)
!         is 
!             a(0) = a(0) / 2
!             call ddct(n, 1, a, ip, w)
!             do j = 0, n - 1
!                 a(j) = a(j) * 2 / n
!             end do
!         .
!
!
! -------- DST (Discrete Sine Transform) / Inverse of DST --------
!     [definition]
!         <case1> IDST (excluding scale)
!             S(k) = sum_j=1^n A(j)*sin(pi*j*(k+1/2)/n), 0<=k<n
!         <case2> DST
!             S(k) = sum_j=0^n-1 a(j)*sin(pi*(j+1/2)*k/n), 0<k<=n
!     [usage]
!         <case1>
!             ip(0) = 0  ! first time only
!             call ddst(n, 1, a, ip, w)
!         <case2>
!             ip(0) = 0  ! first time only
!             call ddst(n, -1, a, ip, w)
!     [parameters]
!         n            :data length (integer)
!                       n >= 2, n = power of 2
!         a(0:n-1)     :input/output data (real*8)
!                       <case1>
!                           input data
!                               a(j) = A(j), 0<j<n
!                               a(0) = A(n)
!                           output data
!                               a(k) = S(k), 0<=k<n
!                       <case2>
!                           output data
!                               a(k) = S(k), 0<k<n
!                               a(0) = S(n)
!         ip(0:*)      :work area for bit reversal (integer)
!                       length of ip >= 2+sqrt(n/2)
!                       strictly, 
!                       length of ip >= 
!                           2+2**(int(log(n/2+0.5)/log(2.0))/2).
!                       ip(0),ip(1) are pointers of the cos/sin table.
!         w(0:n*5/4-1) :cos/sin table (real*8)
!                       w(),ip() are initialized if ip(0) = 0.
!     [remark]
!         Inverse of 
!             call ddst(n, -1, a, ip, w)
!         is 
!             a(0) = a(0) / 2
!             call ddst(n, 1, a, ip, w)
!             do j = 0, n - 1
!                 a(j) = a(j) * 2 / n
!             end do
!         .
!
!
! -------- Cosine Transform of RDFT (Real Symmetric DFT) --------
!     [definition]
!         C(k) = sum_j=0^n a(j)*cos(pi*j*k/n), 0<=k<=n
!     [usage]
!         ip(0) = 0  ! first time only
!         call dfct(n, a, t, ip, w)
!     [parameters]
!         n            :data length - 1 (integer)
!                       n >= 2, n = power of 2
!         a(0:n)       :input/output data (real*8)
!                       output data
!                           a(k) = C(k), 0<=k<=n
!         t(0:n/2)     :work area (real*8)
!         ip(0:*)      :work area for bit reversal (integer)
!                       length of ip >= 2+sqrt(n/4)
!                       strictly, 
!                       length of ip >= 
!                           2+2**(int(log(n/4+0.5)/log(2.0))/2).
!                       ip(0),ip(1) are pointers of the cos/sin table.
!         w(0:n*5/8-1) :cos/sin table (real*8)
!                       w(),ip() are initialized if ip(0) = 0.
!     [remark]
!         Inverse of 
!             a(0) = a(0) / 2
!             a(n) = a(n) / 2
!             call dfct(n, a, t, ip, w)
!         is 
!             a(0) = a(0) / 2
!             a(n) = a(n) / 2
!             call dfct(n, a, t, ip, w)
!             do j = 0, n
!                 a(j) = a(j) * 2 / n
!             end do
!         .
!
!
! -------- Sine Transform of RDFT (Real Anti-symmetric DFT) --------
!     [definition]
!         S(k) = sum_j=1^n-1 a(j)*sin(pi*j*k/n), 0<k<n
!     [usage]
!         ip(0) = 0  ! first time only
!         call dfst(n, a, t, ip, w)
!     [parameters]
!         n            :data length + 1 (integer)
!                       n >= 2, n = power of 2
!         a(0:n-1)     :input/output data (real*8)
!                       output data
!                           a(k) = S(k), 0<k<n
!                       (a(0) is used for work area)
!         t(0:n/2-1)   :work area (real*8)
!         ip(0:*)      :work area for bit reversal (integer)
!                       length of ip >= 2+sqrt(n/4)
!                       strictly, 
!                       length of ip >= 
!                           2+2**(int(log(n/4+0.5)/log(2.0))/2).
!                       ip(0),ip(1) are pointers of the cos/sin table.
!         w(0:n*5/8-1) :cos/sin table (real*8)
!                       w(),ip() are initialized if ip(0) = 0.
!     [remark]
!         Inverse of 
!             call dfst(n, a, t, ip, w)
!         is 
!             call dfst(n, a, t, ip, w)
!             do j = 1, n - 1
!                 a(j) = a(j) * 2 / n
!             end do
!         .
!
!
! Appendix :
!     The cos/sin table is recalculated when the larger table required.
!     w() and ip() are compatible with all routines.
!
!
      subroutine cdft(n, isgn, a, ip, w)
      integer n, isgn, ip(0 : *)
      real*8 a(0 : n - 1), w(0 : *)
      if (n .gt. 4 * ip(0)) then
          call makewt(n / 4, ip, w)
      end if
      if (n .gt. 4) then
          if (isgn .ge. 0) then
              call bitrv2(n, ip(2), a)
              call cftfsub(n, a, w)
          else
              call bitrv2conj(n, ip(2), a)
              call cftbsub(n, a, w)
          end if
      else if (n .eq. 4) then
          call cftfsub(n, a, w)
      end if
      end
!
      subroutine rdft(n, isgn, a, ip, w)
      integer n, isgn, ip(0 : *), nw, nc
      real*8 a(0 : n - 1), w(0 : *), xi
      nw = ip(0)
      if (n .gt. 4 * nw) then
          nw = n / 4
          call makewt(nw, ip, w)
      end if
      nc = ip(1)
      if (n .gt. 4 * nc) then
          nc = n / 4
          call makect(nc, ip, w(nw))
      end if
      if (isgn .ge. 0) then
          if (n .gt. 4) then
              call bitrv2(n, ip(2), a)
              call cftfsub(n, a, w)
              call rftfsub(n, a, nc, w(nw))
          else if (n .eq. 4) then
              call cftfsub(n, a, w)
          end if
          xi = a(0) - a(1)
          a(0) = a(0) + a(1)
          a(1) = xi
      else
          a(1) = 0.5d0 * (a(0) - a(1))
          a(0) = a(0) - a(1)
          if (n .gt. 4) then
              call rftbsub(n, a, nc, w(nw))
              call bitrv2(n, ip(2), a)
              call cftbsub(n, a, w)
          else if (n .eq. 4) then
              call cftfsub(n, a, w)
          end if
      end if
      end
!
      subroutine ddct(n, isgn, a, ip, w)
      integer n, isgn, ip(0 : *), j, nw, nc
      real*8 a(0 : n - 1), w(0 : *), xr
      nw = ip(0)
      if (n .gt. 4 * nw) then
          nw = n / 4
          call makewt(nw, ip, w)
      end if
      nc = ip(1)
      if (n .gt. nc) then
          nc = n
          call makect(nc, ip, w(nw))
      end if
      if (isgn .lt. 0) then
          xr = a(n - 1)
          do j = n - 2, 2, -2
              a(j + 1) = a(j) - a(j - 1)
              a(j) = a(j) + a(j - 1)
          end do
          a(1) = a(0) - xr
          a(0) = a(0) + xr
          if (n .gt. 4) then
              call rftbsub(n, a, nc, w(nw))
              call bitrv2(n, ip(2), a)
              call cftbsub(n, a, w)
          else if (n .eq. 4) then
              call cftfsub(n, a, w)
          end if
      end if
      call dctsub(n, a, nc, w(nw))
      if (isgn .ge. 0) then
          if (n .gt. 4) then
              call bitrv2(n, ip(2), a)
              call cftfsub(n, a, w)
              call rftfsub(n, a, nc, w(nw))
          else if (n .eq. 4) then
              call cftfsub(n, a, w)
          end if
          xr = a(0) - a(1)
          a(0) = a(0) + a(1)
          do j = 2, n - 2, 2
              a(j - 1) = a(j) - a(j + 1)
              a(j) = a(j) + a(j + 1)
          end do
          a(n - 1) = xr
      end if
      end
!
      subroutine ddst(n, isgn, a, ip, w)
      integer n, isgn, ip(0 : *), j, nw, nc
      real*8 a(0 : n - 1), w(0 : *), xr
      nw = ip(0)
      if (n .gt. 4 * nw) then
          nw = n / 4
          call makewt(nw, ip, w)
      end if
      nc = ip(1)
      if (n .gt. nc) then
          nc = n
          call makect(nc, ip, w(nw))
      end if
      if (isgn .lt. 0) then
          xr = a(n - 1)
          do j = n - 2, 2, -2
              a(j + 1) = -a(j) - a(j - 1)
              a(j) = a(j) - a(j - 1)
          end do
          a(1) = a(0) + xr
          a(0) = a(0) - xr
          if (n .gt. 4) then
              call rftbsub(n, a, nc, w(nw))
              call bitrv2(n, ip(2), a)
              call cftbsub(n, a, w)
          else if (n .eq. 4) then
              call cftfsub(n, a, w)
          end if
      end if
      call dstsub(n, a, nc, w(nw))
      if (isgn .ge. 0) then
          if (n .gt. 4) then
              call bitrv2(n, ip(2), a)
              call cftfsub(n, a, w)
              call rftfsub(n, a, nc, w(nw))
          else if (n .eq. 4) then
              call cftfsub(n, a, w)
          end if
          xr = a(0) - a(1)
          a(0) = a(0) + a(1)
          do j = 2, n - 2, 2
              a(j - 1) = -a(j) - a(j + 1)
              a(j) = a(j) - a(j + 1)
          end do
          a(n - 1) = -xr
      end if
      end
!
      subroutine dfct(n, a, t, ip, w)
      integer n, ip(0 : *), j, k, l, m, mh, nw, nc
      real*8 a(0 : n), t(0 : n / 2), w(0 : *), xr, xi, yr, yi
      nw = ip(0)
      if (n .gt. 8 * nw) then
          nw = n / 8
          call makewt(nw, ip, w)
      end if
      nc = ip(1)
      if (n .gt. 2 * nc) then
          nc = n / 2
          call makect(nc, ip, w(nw))
      end if
      m = n / 2
      yi = a(m)
      xi = a(0) + a(n)
      a(0) = a(0) - a(n)
      t(0) = xi - yi
      t(m) = xi + yi
      if (n .gt. 2) then
          mh = m / 2
          do j = 1, mh - 1
              k = m - j
              xr = a(j) - a(n - j)
              xi = a(j) + a(n - j)
              yr = a(k) - a(n - k)
              yi = a(k) + a(n - k)
              a(j) = xr
              a(k) = yr
              t(j) = xi - yi
              t(k) = xi + yi
          end do
          t(mh) = a(mh) + a(n - mh)
          a(mh) = a(mh) - a(n - mh)
          call dctsub(m, a, nc, w(nw))
          if (m .gt. 4) then
              call bitrv2(m, ip(2), a)
              call cftfsub(m, a, w)
              call rftfsub(m, a, nc, w(nw))
          else if (m .eq. 4) then
              call cftfsub(m, a, w)
          end if
          a(n - 1) = a(0) - a(1)
          a(1) = a(0) + a(1)
          do j = m - 2, 2, -2
              a(2 * j + 1) = a(j) + a(j + 1)
              a(2 * j - 1) = a(j) - a(j + 1)
          end do
          l = 2
          m = mh
          do while (m .ge. 2)
              call dctsub(m, t, nc, w(nw))
              if (m .gt. 4) then
                  call bitrv2(m, ip(2), t)
                  call cftfsub(m, t, w)
                  call rftfsub(m, t, nc, w(nw))
              else if (m .eq. 4) then
                  call cftfsub(m, t, w)
              end if
              a(n - l) = t(0) - t(1)
              a(l) = t(0) + t(1)
              k = 0
              do j = 2, m - 2, 2
                  k = k + 4 * l
                  a(k - l) = t(j) - t(j + 1)
                  a(k + l) = t(j) + t(j + 1)
              end do
              l = 2 * l
              mh = m / 2
              do j = 0, mh - 1
                  k = m - j
                  t(j) = t(m + k) - t(m + j)
                  t(k) = t(m + k) + t(m + j)
              end do
              t(mh) = t(m + mh)
              m = mh
          end do
          a(l) = t(0)
          a(n) = t(2) - t(1)
          a(0) = t(2) + t(1)
      else
          a(1) = a(0)
          a(2) = t(0)
          a(0) = t(1)
      end if
      end
!
      subroutine dfst(n, a, t, ip, w)
      integer n, ip(0 : *), j, k, l, m, mh, nw, nc
      real*8 a(0 : n - 1), t(0 : n / 2 - 1), w(0 : *), xr, xi, yr, yi
      nw = ip(0)
      if (n .gt. 8 * nw) then
          nw = n / 8
          call makewt(nw, ip, w)
      end if
      nc = ip(1)
      if (n .gt. 2 * nc) then
          nc = n / 2
          call makect(nc, ip, w(nw))
      end if
      if (n .gt. 2) then
          m = n / 2
          mh = m / 2
          do j = 1, mh - 1
              k = m - j
              xr = a(j) + a(n - j)
              xi = a(j) - a(n - j)
              yr = a(k) + a(n - k)
              yi = a(k) - a(n - k)
              a(j) = xr
              a(k) = yr
              t(j) = xi + yi
              t(k) = xi - yi
          end do
          t(0) = a(mh) - a(n - mh)
          a(mh) = a(mh) + a(n - mh)
          a(0) = a(m)
          call dstsub(m, a, nc, w(nw))
          if (m .gt. 4) then
              call bitrv2(m, ip(2), a)
              call cftfsub(m, a, w)
              call rftfsub(m, a, nc, w(nw))
          else if (m .eq. 4) then
              call cftfsub(m, a, w)
          end if
          a(n - 1) = a(1) - a(0)
          a(1) = a(0) + a(1)
          do j = m - 2, 2, -2
              a(2 * j + 1) = a(j) - a(j + 1)
              a(2 * j - 1) = -a(j) - a(j + 1)
          end do
          l = 2
          m = mh
          do while (m .ge. 2)
              call dstsub(m, t, nc, w(nw))
              if (m .gt. 4) then
                  call bitrv2(m, ip(2), t)
                  call cftfsub(m, t, w)
                  call rftfsub(m, t, nc, w(nw))
              else if (m .eq. 4) then
                  call cftfsub(m, t, w)
              end if
              a(n - l) = t(1) - t(0)
              a(l) = t(0) + t(1)
              k = 0
              do j = 2, m - 2, 2
                  k = k + 4 * l
                  a(k - l) = -t(j) - t(j + 1)
                  a(k + l) = t(j) - t(j + 1)
              end do
              l = 2 * l
              mh = m / 2
              do j = 1, mh - 1
                  k = m - j
                  t(j) = t(m + k) + t(m + j)
                  t(k) = t(m + k) - t(m + j)
              end do
              t(0) = t(m + mh)
              m = mh
          end do
          a(l) = t(0)
      end if
      a(0) = 0
      end
!
! -------- initializing routines --------
!
      subroutine makewt(nw, ip, w)
      integer nw, ip(0 : *), j, nwh
      real*8 w(0 : nw - 1), delta, x, y
      ip(0) = nw
      ip(1) = 1
      if (nw .gt. 2) then
          nwh = nw / 2
          delta = atan(1.0d0) / nwh
          w(0) = 1
          w(1) = 0
          w(nwh) = cos(delta * nwh)
          w(nwh + 1) = w(nwh)
          if (nwh .gt. 2) then
              do j = 2, nwh - 2, 2
                  x = cos(delta * j)
                  y = sin(delta * j)
                  w(j) = x
                  w(j + 1) = y
                  w(nw - j) = y
                  w(nw - j + 1) = x
              end do
              do j = nwh - 2, 2, -2
                  x = w(2 * j)
                  y = w(2 * j + 1)
                  w(nwh + j) = x
                  w(nwh + j + 1) = y
              end do
              call bitrv2(nw, ip(2), w)
          end if
      end if
      end
!
      subroutine makect(nc, ip, c)
      integer nc, ip(0 : *), j, nch
      real*8 c(0 : nc - 1), delta
      ip(1) = nc
      if (nc .gt. 1) then
          nch = nc / 2
          delta = atan(1.0d0) / nch
          c(0) = cos(delta * nch)
          c(nch) = 0.5d0 * c(0)
          do j = 1, nch - 1
              c(j) = 0.5d0 * cos(delta * j)
              c(nc - j) = 0.5d0 * sin(delta * j)
          end do
      end if
      end
!
! -------- child routines --------
!
      subroutine bitrv2(n, ip, a)
      integer n, ip(0 : *), j, j1, k, k1, l, m, m2
      real*8 a(0 : n - 1), xr, xi, yr, yi
      ip(0) = 0
      l = n
      m = 1
      do while (8 * m .lt. l)
          l = l / 2
          do j = 0, m - 1
              ip(m + j) = ip(j) + l
          end do
          m = m * 2
      end do
      m2 = 2 * m
      if (8 * m .eq. l) then
          do k = 0, m - 1
              do j = 0, k - 1
                  j1 = 2 * j + ip(k)
                  k1 = 2 * k + ip(j)
                  xr = a(j1)
                  xi = a(j1 + 1)
                  yr = a(k1)
                  yi = a(k1 + 1)
                  a(j1) = yr
                  a(j1 + 1) = yi
                  a(k1) = xr
                  a(k1 + 1) = xi
                  j1 = j1 + m2
                  k1 = k1 + 2 * m2
                  xr = a(j1)
                  xi = a(j1 + 1)
                  yr = a(k1)
                  yi = a(k1 + 1)
                  a(j1) = yr
                  a(j1 + 1) = yi
                  a(k1) = xr
                  a(k1 + 1) = xi
                  j1 = j1 + m2
                  k1 = k1 - m2
                  xr = a(j1)
                  xi = a(j1 + 1)
                  yr = a(k1)
                  yi = a(k1 + 1)
                  a(j1) = yr
                  a(j1 + 1) = yi
                  a(k1) = xr
                  a(k1 + 1) = xi
                  j1 = j1 + m2
                  k1 = k1 + 2 * m2
                  xr = a(j1)
                  xi = a(j1 + 1)
                  yr = a(k1)
                  yi = a(k1 + 1)
                  a(j1) = yr
                  a(j1 + 1) = yi
                  a(k1) = xr
                  a(k1 + 1) = xi
              end do
              j1 = 2 * k + m2 + ip(k)
              k1 = j1 + m2
              xr = a(j1)
              xi = a(j1 + 1)
              yr = a(k1)
              yi = a(k1 + 1)
              a(j1) = yr
              a(j1 + 1) = yi
              a(k1) = xr
              a(k1 + 1) = xi
          end do
      else
          do k = 1, m - 1
              do j = 0, k - 1
                  j1 = 2 * j + ip(k)
                  k1 = 2 * k + ip(j)
                  xr = a(j1)
                  xi = a(j1 + 1)
                  yr = a(k1)
                  yi = a(k1 + 1)
                  a(j1) = yr
                  a(j1 + 1) = yi
                  a(k1) = xr
                  a(k1 + 1) = xi
                  j1 = j1 + m2
                  k1 = k1 + m2
                  xr = a(j1)
                  xi = a(j1 + 1)
                  yr = a(k1)
                  yi = a(k1 + 1)
                  a(j1) = yr
                  a(j1 + 1) = yi
                  a(k1) = xr
                  a(k1 + 1) = xi
              end do
          end do
      end if
      end
!
      subroutine bitrv2conj(n, ip, a)
      integer n, ip(0 : *), j, j1, k, k1, l, m, m2
      real*8 a(0 : n - 1), xr, xi, yr, yi
      ip(0) = 0
      l = n
      m = 1
      do while (8 * m .lt. l)
          l = l / 2
          do j = 0, m - 1
              ip(m + j) = ip(j) + l
          end do
          m = m * 2
      end do
      m2 = 2 * m
      if (8 * m .eq. l) then
          do k = 0, m - 1
              do j = 0, k - 1
                  j1 = 2 * j + ip(k)
                  k1 = 2 * k + ip(j)
                  xr = a(j1)
                  xi = -a(j1 + 1)
                  yr = a(k1)
                  yi = -a(k1 + 1)
                  a(j1) = yr
                  a(j1 + 1) = yi
                  a(k1) = xr
                  a(k1 + 1) = xi
                  j1 = j1 + m2
                  k1 = k1 + 2 * m2
                  xr = a(j1)
                  xi = -a(j1 + 1)
                  yr = a(k1)
                  yi = -a(k1 + 1)
                  a(j1) = yr
                  a(j1 + 1) = yi
                  a(k1) = xr
                  a(k1 + 1) = xi
                  j1 = j1 + m2
                  k1 = k1 - m2
                  xr = a(j1)
                  xi = -a(j1 + 1)
                  yr = a(k1)
                  yi = -a(k1 + 1)
                  a(j1) = yr
                  a(j1 + 1) = yi
                  a(k1) = xr
                  a(k1 + 1) = xi
                  j1 = j1 + m2
                  k1 = k1 + 2 * m2
                  xr = a(j1)
                  xi = -a(j1 + 1)
                  yr = a(k1)
                  yi = -a(k1 + 1)
                  a(j1) = yr
                  a(j1 + 1) = yi
                  a(k1) = xr
                  a(k1 + 1) = xi
              end do
              k1 = 2 * k + ip(k)
              a(k1 + 1) = -a(k1 + 1)
              j1 = k1 + m2
              k1 = j1 + m2
              xr = a(j1)
              xi = -a(j1 + 1)
              yr = a(k1)
              yi = -a(k1 + 1)
              a(j1) = yr
              a(j1 + 1) = yi
              a(k1) = xr
              a(k1 + 1) = xi
              k1 = k1 + m2
              a(k1 + 1) = -a(k1 + 1)
          end do
      else
          a(1) = -a(1)
          a(m2 + 1) = -a(m2 + 1)
          do k = 1, m - 1
              do j = 0, k - 1
                  j1 = 2 * j + ip(k)
                  k1 = 2 * k + ip(j)
                  xr = a(j1)
                  xi = -a(j1 + 1)
                  yr = a(k1)
                  yi = -a(k1 + 1)
                  a(j1) = yr
                  a(j1 + 1) = yi
                  a(k1) = xr
                  a(k1 + 1) = xi
                  j1 = j1 + m2
                  k1 = k1 + m2
                  xr = a(j1)
                  xi = -a(j1 + 1)
                  yr = a(k1)
                  yi = -a(k1 + 1)
                  a(j1) = yr
                  a(j1 + 1) = yi
                  a(k1) = xr
                  a(k1 + 1) = xi
              end do
              k1 = 2 * k + ip(k)
              a(k1 + 1) = -a(k1 + 1)
              a(k1 + m2 + 1) = -a(k1 + m2 + 1)
          end do
      end if
      end
!
      subroutine cftfsub(n, a, w)
      integer n, j, j1, j2, j3, l
      real*8 a(0 : n - 1), w(0 : *)
      real*8 x0r, x0i, x1r, x1i, x2r, x2i, x3r, x3i
      l = 2
      if (n .ge. 16) then
          call cft1st(n, a, w)
          l = 16
          do while (8 * l .le. n)
              call cftmdl(n, l, a, w)
              l = 8 * l
          end do
      end if
      if (2 * l .lt. n) then
          do j = 0, l - 2, 2
              j1 = j + l
              j2 = j1 + l
              j3 = j2 + l
              x0r = a(j) + a(j1)
              x0i = a(j + 1) + a(j1 + 1)
              x1r = a(j) - a(j1)
              x1i = a(j + 1) - a(j1 + 1)
              x2r = a(j2) + a(j3)
              x2i = a(j2 + 1) + a(j3 + 1)
              x3r = a(j2) - a(j3)
              x3i = a(j2 + 1) - a(j3 + 1)
              a(j) = x0r + x2r
              a(j + 1) = x0i + x2i
              a(j2) = x0r - x2r
              a(j2 + 1) = x0i - x2i
              a(j1) = x1r - x3i
              a(j1 + 1) = x1i + x3r
              a(j3) = x1r + x3i
              a(j3 + 1) = x1i - x3r
          end do
      else if (2 * l .eq. n) then
          do j = 0, l - 2, 2
              j1 = j + l
              x0r = a(j) - a(j1)
              x0i = a(j + 1) - a(j1 + 1)
              a(j) = a(j) + a(j1)
              a(j + 1) = a(j + 1) + a(j1 + 1)
              a(j1) = x0r
              a(j1 + 1) = x0i
          end do
      end if
      end
!
      subroutine cftbsub(n, a, w)
      integer n, j, j1, j2, j3, j4, j5, j6, j7, l
      real*8 a(0 : n - 1), w(0 : *)
      real*8 wn4r, x0r, x0i, x1r, x1i, x2r, x2i, x3r, x3i
      real*8 y0r, y0i, y1r, y1i, y2r, y2i, y3r, y3i
      real*8 y4r, y4i, y5r, y5i, y6r, y6i, y7r, y7i
      l = 2
      if (n .gt. 16) then
          call cft1st(n, a, w)
          l = 16
          do while (8 * l .lt. n)
              call cftmdl(n, l, a, w)
              l = 8 * l
          end do
      end if
      if (4 * l .lt. n) then
          wn4r = w(2)
          do j = 0, l - 2, 2
              j1 = j + l
              j2 = j1 + l
              j3 = j2 + l
              j4 = j3 + l
              j5 = j4 + l
              j6 = j5 + l
              j7 = j6 + l
              x0r = a(j) + a(j1)
              x0i = -a(j + 1) - a(j1 + 1)
              x1r = a(j) - a(j1)
              x1i = -a(j + 1) + a(j1 + 1)
              x2r = a(j2) + a(j3)
              x2i = a(j2 + 1) + a(j3 + 1)
              x3r = a(j2) - a(j3)
              x3i = a(j2 + 1) - a(j3 + 1)
              y0r = x0r + x2r
              y0i = x0i - x2i
              y2r = x0r - x2r
              y2i = x0i + x2i
              y1r = x1r - x3i
              y1i = x1i - x3r
              y3r = x1r + x3i
              y3i = x1i + x3r
              x0r = a(j4) + a(j5)
              x0i = a(j4 + 1) + a(j5 + 1)
              x1r = a(j4) - a(j5)
              x1i = a(j4 + 1) - a(j5 + 1)
              x2r = a(j6) + a(j7)
              x2i = a(j6 + 1) + a(j7 + 1)
              x3r = a(j6) - a(j7)
              x3i = a(j6 + 1) - a(j7 + 1)
              y4r = x0r + x2r
              y4i = x0i + x2i
              y6r = x0r - x2r
              y6i = x0i - x2i
              x0r = x1r - x3i
              x0i = x1i + x3r
              x2r = x1r + x3i
              x2i = x1i - x3r
              y5r = wn4r * (x0r - x0i)
              y5i = wn4r * (x0r + x0i)
              y7r = wn4r * (x2r - x2i)
              y7i = wn4r * (x2r + x2i)
              a(j1) = y1r + y5r
              a(j1 + 1) = y1i - y5i
              a(j5) = y1r - y5r
              a(j5 + 1) = y1i + y5i
              a(j3) = y3r - y7i
              a(j3 + 1) = y3i - y7r
              a(j7) = y3r + y7i
              a(j7 + 1) = y3i + y7r
              a(j) = y0r + y4r
              a(j + 1) = y0i - y4i
              a(j4) = y0r - y4r
              a(j4 + 1) = y0i + y4i
              a(j2) = y2r - y6i
              a(j2 + 1) = y2i - y6r
              a(j6) = y2r + y6i
              a(j6 + 1) = y2i + y6r
          end do
      else if (4 * l .eq. n) then
          do j = 0, l - 2, 2
              j1 = j + l
              j2 = j1 + l
              j3 = j2 + l
              x0r = a(j) + a(j1)
              x0i = -a(j + 1) - a(j1 + 1)
              x1r = a(j) - a(j1)
              x1i = -a(j + 1) + a(j1 + 1)
              x2r = a(j2) + a(j3)
              x2i = a(j2 + 1) + a(j3 + 1)
              x3r = a(j2) - a(j3)
              x3i = a(j2 + 1) - a(j3 + 1)
              a(j) = x0r + x2r
              a(j + 1) = x0i - x2i
              a(j2) = x0r - x2r
              a(j2 + 1) = x0i + x2i
              a(j1) = x1r - x3i
              a(j1 + 1) = x1i - x3r
              a(j3) = x1r + x3i
              a(j3 + 1) = x1i + x3r
          end do
      else
          do j = 0, l - 2, 2
              j1 = j + l
              x0r = a(j) - a(j1)
              x0i = -a(j + 1) + a(j1 + 1)
              a(j) = a(j) + a(j1)
              a(j + 1) = -a(j + 1) - a(j1 + 1)
              a(j1) = x0r
              a(j1 + 1) = x0i
          end do
      end if
      end
!
      subroutine cft1st(n, a, w)
      integer n, j, k1
      real*8 a(0 : n - 1), w(0 : *)
      real*8 wn4r, wtmp, wk1r, wk1i, wk2r, wk2i, wk3r, wk3i
      real*8 wk4r, wk4i, wk5r, wk5i, wk6r, wk6i, wk7r, wk7i
      real*8 x0r, x0i, x1r, x1i, x2r, x2i, x3r, x3i
      real*8 y0r, y0i, y1r, y1i, y2r, y2i, y3r, y3i
      real*8 y4r, y4i, y5r, y5i, y6r, y6i, y7r, y7i
      wn4r = w(2)
      x0r = a(0) + a(2)
      x0i = a(1) + a(3)
      x1r = a(0) - a(2)
      x1i = a(1) - a(3)
      x2r = a(4) + a(6)
      x2i = a(5) + a(7)
      x3r = a(4) - a(6)
      x3i = a(5) - a(7)
      y0r = x0r + x2r
      y0i = x0i + x2i
      y2r = x0r - x2r
      y2i = x0i - x2i
      y1r = x1r - x3i
      y1i = x1i + x3r
      y3r = x1r + x3i
      y3i = x1i - x3r
      x0r = a(8) + a(10)
      x0i = a(9) + a(11)
      x1r = a(8) - a(10)
      x1i = a(9) - a(11)
      x2r = a(12) + a(14)
      x2i = a(13) + a(15)
      x3r = a(12) - a(14)
      x3i = a(13) - a(15)
      y4r = x0r + x2r
      y4i = x0i + x2i
      y6r = x0r - x2r
      y6i = x0i - x2i
      x0r = x1r - x3i
      x0i = x1i + x3r
      x2r = x1r + x3i
      x2i = x1i - x3r
      y5r = wn4r * (x0r - x0i)
      y5i = wn4r * (x0r + x0i)
      y7r = wn4r * (x2r - x2i)
      y7i = wn4r * (x2r + x2i)
      a(2) = y1r + y5r
      a(3) = y1i + y5i
      a(10) = y1r - y5r
      a(11) = y1i - y5i
      a(6) = y3r - y7i
      a(7) = y3i + y7r
      a(14) = y3r + y7i
      a(15) = y3i - y7r
      a(0) = y0r + y4r
      a(1) = y0i + y4i
      a(8) = y0r - y4r
      a(9) = y0i - y4i
      a(4) = y2r - y6i
      a(5) = y2i + y6r
      a(12) = y2r + y6i
      a(13) = y2i - y6r
      if (n .gt. 16) then
          wk1r = w(4)
          wk1i = w(5)
          x0r = a(16) + a(18)
          x0i = a(17) + a(19)
          x1r = a(16) - a(18)
          x1i = a(17) - a(19)
          x2r = a(20) + a(22)
          x2i = a(21) + a(23)
          x3r = a(20) - a(22)
          x3i = a(21) - a(23)
          y0r = x0r + x2r
          y0i = x0i + x2i
          y2r = x0r - x2r
          y2i = x0i - x2i
          y1r = x1r - x3i
          y1i = x1i + x3r
          y3r = x1r + x3i
          y3i = x1i - x3r
          x0r = a(24) + a(26)
          x0i = a(25) + a(27)
          x1r = a(24) - a(26)
          x1i = a(25) - a(27)
          x2r = a(28) + a(30)
          x2i = a(29) + a(31)
          x3r = a(28) - a(30)
          x3i = a(29) - a(31)
          y4r = x0r + x2r
          y4i = x0i + x2i
          y6r = x0r - x2r
          y6i = x0i - x2i
          x0r = x1r - x3i
          x0i = x1i + x3r
          x2r = x1r + x3i
          x2i = x3r - x1i
          y5r = wk1i * x0r - wk1r * x0i
          y5i = wk1i * x0i + wk1r * x0r
          y7r = wk1r * x2r + wk1i * x2i
          y7i = wk1r * x2i - wk1i * x2r
          x0r = wk1r * y1r - wk1i * y1i
          x0i = wk1r * y1i + wk1i * y1r
          a(18) = x0r + y5r
          a(19) = x0i + y5i
          a(26) = y5i - x0i
          a(27) = x0r - y5r
          x0r = wk1i * y3r - wk1r * y3i
          x0i = wk1i * y3i + wk1r * y3r
          a(22) = x0r - y7r
          a(23) = x0i + y7i
          a(30) = y7i - x0i
          a(31) = x0r + y7r
          a(16) = y0r + y4r
          a(17) = y0i + y4i
          a(24) = y4i - y0i
          a(25) = y0r - y4r
          x0r = y2r - y6i
          x0i = y2i + y6r
          a(20) = wn4r * (x0r - x0i)
          a(21) = wn4r * (x0i + x0r)
          x0r = y6r - y2i
          x0i = y2r + y6i
          a(28) = wn4r * (x0r - x0i)
          a(29) = wn4r * (x0i + x0r)
          k1 = 4
          do j = 32, n - 16, 16
              k1 = k1 + 4
              wk1r = w(k1)
              wk1i = w(k1 + 1)
              wk2r = w(k1 + 2)
              wk2i = w(k1 + 3)
              wtmp = 2 * wk2i
              wk3r = wk1r - wtmp * wk1i
              wk3i = wtmp * wk1r - wk1i
              wk4r = 1 - wtmp * wk2i
              wk4i = wtmp * wk2r
              wtmp = 2 * wk4i
              wk5r = wk3r - wtmp * wk1i
              wk5i = wtmp * wk1r - wk3i
              wk6r = wk2r - wtmp * wk2i
              wk6i = wtmp * wk2r - wk2i
              wk7r = wk1r - wtmp * wk3i
              wk7i = wtmp * wk3r - wk1i
              x0r = a(j) + a(j + 2)
              x0i = a(j + 1) + a(j + 3)
              x1r = a(j) - a(j + 2)
              x1i = a(j + 1) - a(j + 3)
              x2r = a(j + 4) + a(j + 6)
              x2i = a(j + 5) + a(j + 7)
              x3r = a(j + 4) - a(j + 6)
              x3i = a(j + 5) - a(j + 7)
              y0r = x0r + x2r
              y0i = x0i + x2i
              y2r = x0r - x2r
              y2i = x0i - x2i
              y1r = x1r - x3i
              y1i = x1i + x3r
              y3r = x1r + x3i
              y3i = x1i - x3r
              x0r = a(j + 8) + a(j + 10)
              x0i = a(j + 9) + a(j + 11)
              x1r = a(j + 8) - a(j + 10)
              x1i = a(j + 9) - a(j + 11)
              x2r = a(j + 12) + a(j + 14)
              x2i = a(j + 13) + a(j + 15)
              x3r = a(j + 12) - a(j + 14)
              x3i = a(j + 13) - a(j + 15)
              y4r = x0r + x2r
              y4i = x0i + x2i
              y6r = x0r - x2r
              y6i = x0i - x2i
              x0r = x1r - x3i
              x0i = x1i + x3r
              x2r = x1r + x3i
              x2i = x1i - x3r
              y5r = wn4r * (x0r - x0i)
              y5i = wn4r * (x0r + x0i)
              y7r = wn4r * (x2r - x2i)
              y7i = wn4r * (x2r + x2i)
              x0r = y1r + y5r
              x0i = y1i + y5i
              a(j + 2) = wk1r * x0r - wk1i * x0i
              a(j + 3) = wk1r * x0i + wk1i * x0r
              x0r = y1r - y5r
              x0i = y1i - y5i
              a(j + 10) = wk5r * x0r - wk5i * x0i
              a(j + 11) = wk5r * x0i + wk5i * x0r
              x0r = y3r - y7i
              x0i = y3i + y7r
              a(j + 6) = wk3r * x0r - wk3i * x0i
              a(j + 7) = wk3r * x0i + wk3i * x0r
              x0r = y3r + y7i
              x0i = y3i - y7r
              a(j + 14) = wk7r * x0r - wk7i * x0i
              a(j + 15) = wk7r * x0i + wk7i * x0r
              a(j) = y0r + y4r
              a(j + 1) = y0i + y4i
              x0r = y0r - y4r
              x0i = y0i - y4i
              a(j + 8) = wk4r * x0r - wk4i * x0i
              a(j + 9) = wk4r * x0i + wk4i * x0r
              x0r = y2r - y6i
              x0i = y2i + y6r
              a(j + 4) = wk2r * x0r - wk2i * x0i
              a(j + 5) = wk2r * x0i + wk2i * x0r
              x0r = y2r + y6i
              x0i = y2i - y6r
              a(j + 12) = wk6r * x0r - wk6i * x0i
              a(j + 13) = wk6r * x0i + wk6i * x0r
          end do
      end if
      end
!
      subroutine cftmdl(n, l, a, w)
      integer n, l, j, j1, j2, j3, j4, j5, j6, j7, k, k1, m
      real*8 a(0 : n - 1), w(0 : *)
      real*8 wn4r, wtmp, wk1r, wk1i, wk2r, wk2i, wk3r, wk3i
      real*8 wk4r, wk4i, wk5r, wk5i, wk6r, wk6i, wk7r, wk7i
      real*8 x0r, x0i, x1r, x1i, x2r, x2i, x3r, x3i
      real*8 y0r, y0i, y1r, y1i, y2r, y2i, y3r, y3i
      real*8 y4r, y4i, y5r, y5i, y6r, y6i, y7r, y7i
      m = 8 * l
      wn4r = w(2)
      do j = 0, l - 2, 2
          j1 = j + l
          j2 = j1 + l
          j3 = j2 + l
          j4 = j3 + l
          j5 = j4 + l
          j6 = j5 + l
          j7 = j6 + l
          x0r = a(j) + a(j1)
          x0i = a(j + 1) + a(j1 + 1)
          x1r = a(j) - a(j1)
          x1i = a(j + 1) - a(j1 + 1)
          x2r = a(j2) + a(j3)
          x2i = a(j2 + 1) + a(j3 + 1)
          x3r = a(j2) - a(j3)
          x3i = a(j2 + 1) - a(j3 + 1)
          y0r = x0r + x2r
          y0i = x0i + x2i
          y2r = x0r - x2r
          y2i = x0i - x2i
          y1r = x1r - x3i
          y1i = x1i + x3r
          y3r = x1r + x3i
          y3i = x1i - x3r
          x0r = a(j4) + a(j5)
          x0i = a(j4 + 1) + a(j5 + 1)
          x1r = a(j4) - a(j5)
          x1i = a(j4 + 1) - a(j5 + 1)
          x2r = a(j6) + a(j7)
          x2i = a(j6 + 1) + a(j7 + 1)
          x3r = a(j6) - a(j7)
          x3i = a(j6 + 1) - a(j7 + 1)
          y4r = x0r + x2r
          y4i = x0i + x2i
          y6r = x0r - x2r
          y6i = x0i - x2i
          x0r = x1r - x3i
          x0i = x1i + x3r
          x2r = x1r + x3i
          x2i = x1i - x3r
          y5r = wn4r * (x0r - x0i)
          y5i = wn4r * (x0r + x0i)
          y7r = wn4r * (x2r - x2i)
          y7i = wn4r * (x2r + x2i)
          a(j1) = y1r + y5r
          a(j1 + 1) = y1i + y5i
          a(j5) = y1r - y5r
          a(j5 + 1) = y1i - y5i
          a(j3) = y3r - y7i
          a(j3 + 1) = y3i + y7r
          a(j7) = y3r + y7i
          a(j7 + 1) = y3i - y7r
          a(j) = y0r + y4r
          a(j + 1) = y0i + y4i
          a(j4) = y0r - y4r
          a(j4 + 1) = y0i - y4i
          a(j2) = y2r - y6i
          a(j2 + 1) = y2i + y6r
          a(j6) = y2r + y6i
          a(j6 + 1) = y2i - y6r
      end do
      if (m .lt. n) then
          wk1r = w(4)
          wk1i = w(5)
          do j = m, l + m - 2, 2
              j1 = j + l
              j2 = j1 + l
              j3 = j2 + l
              j4 = j3 + l
              j5 = j4 + l
              j6 = j5 + l
              j7 = j6 + l
              x0r = a(j) + a(j1)
              x0i = a(j + 1) + a(j1 + 1)
              x1r = a(j) - a(j1)
              x1i = a(j + 1) - a(j1 + 1)
              x2r = a(j2) + a(j3)
              x2i = a(j2 + 1) + a(j3 + 1)
              x3r = a(j2) - a(j3)
              x3i = a(j2 + 1) - a(j3 + 1)
              y0r = x0r + x2r
              y0i = x0i + x2i
              y2r = x0r - x2r
              y2i = x0i - x2i
              y1r = x1r - x3i
              y1i = x1i + x3r
              y3r = x1r + x3i
              y3i = x1i - x3r
              x0r = a(j4) + a(j5)
              x0i = a(j4 + 1) + a(j5 + 1)
              x1r = a(j4) - a(j5)
              x1i = a(j4 + 1) - a(j5 + 1)
              x2r = a(j6) + a(j7)
              x2i = a(j6 + 1) + a(j7 + 1)
              x3r = a(j6) - a(j7)
              x3i = a(j6 + 1) - a(j7 + 1)
              y4r = x0r + x2r
              y4i = x0i + x2i
              y6r = x0r - x2r
              y6i = x0i - x2i
              x0r = x1r - x3i
              x0i = x1i + x3r
              x2r = x1r + x3i
              x2i = x3r - x1i
              y5r = wk1i * x0r - wk1r * x0i
              y5i = wk1i * x0i + wk1r * x0r
              y7r = wk1r * x2r + wk1i * x2i
              y7i = wk1r * x2i - wk1i * x2r
              x0r = wk1r * y1r - wk1i * y1i
              x0i = wk1r * y1i + wk1i * y1r
              a(j1) = x0r + y5r
              a(j1 + 1) = x0i + y5i
              a(j5) = y5i - x0i
              a(j5 + 1) = x0r - y5r
              x0r = wk1i * y3r - wk1r * y3i
              x0i = wk1i * y3i + wk1r * y3r
              a(j3) = x0r - y7r
              a(j3 + 1) = x0i + y7i
              a(j7) = y7i - x0i
              a(j7 + 1) = x0r + y7r
              a(j) = y0r + y4r
              a(j + 1) = y0i + y4i
              a(j4) = y4i - y0i
              a(j4 + 1) = y0r - y4r
              x0r = y2r - y6i
              x0i = y2i + y6r
              a(j2) = wn4r * (x0r - x0i)
              a(j2 + 1) = wn4r * (x0i + x0r)
              x0r = y6r - y2i
              x0i = y2r + y6i
              a(j6) = wn4r * (x0r - x0i)
              a(j6 + 1) = wn4r * (x0i + x0r)
          end do
          k1 = 4
          do k = 2 * m, n - m, m
              k1 = k1 + 4
              wk1r = w(k1)
              wk1i = w(k1 + 1)
              wk2r = w(k1 + 2)
              wk2i = w(k1 + 3)
              wtmp = 2 * wk2i
              wk3r = wk1r - wtmp * wk1i
              wk3i = wtmp * wk1r - wk1i
              wk4r = 1 - wtmp * wk2i
              wk4i = wtmp * wk2r
              wtmp = 2 * wk4i
              wk5r = wk3r - wtmp * wk1i
              wk5i = wtmp * wk1r - wk3i
              wk6r = wk2r - wtmp * wk2i
              wk6i = wtmp * wk2r - wk2i
              wk7r = wk1r - wtmp * wk3i
              wk7i = wtmp * wk3r - wk1i
              do j = k, l + k - 2, 2
                  j1 = j + l
                  j2 = j1 + l
                  j3 = j2 + l
                  j4 = j3 + l
                  j5 = j4 + l
                  j6 = j5 + l
                  j7 = j6 + l
                  x0r = a(j) + a(j1)
                  x0i = a(j + 1) + a(j1 + 1)
                  x1r = a(j) - a(j1)
                  x1i = a(j + 1) - a(j1 + 1)
                  x2r = a(j2) + a(j3)
                  x2i = a(j2 + 1) + a(j3 + 1)
                  x3r = a(j2) - a(j3)
                  x3i = a(j2 + 1) - a(j3 + 1)
                  y0r = x0r + x2r
                  y0i = x0i + x2i
                  y2r = x0r - x2r
                  y2i = x0i - x2i
                  y1r = x1r - x3i
                  y1i = x1i + x3r
                  y3r = x1r + x3i
                  y3i = x1i - x3r
                  x0r = a(j4) + a(j5)
                  x0i = a(j4 + 1) + a(j5 + 1)
                  x1r = a(j4) - a(j5)
                  x1i = a(j4 + 1) - a(j5 + 1)
                  x2r = a(j6) + a(j7)
                  x2i = a(j6 + 1) + a(j7 + 1)
                  x3r = a(j6) - a(j7)
                  x3i = a(j6 + 1) - a(j7 + 1)
                  y4r = x0r + x2r
                  y4i = x0i + x2i
                  y6r = x0r - x2r
                  y6i = x0i - x2i
                  x0r = x1r - x3i
                  x0i = x1i + x3r
                  x2r = x1r + x3i
                  x2i = x1i - x3r
                  y5r = wn4r * (x0r - x0i)
                  y5i = wn4r * (x0r + x0i)
                  y7r = wn4r * (x2r - x2i)
                  y7i = wn4r * (x2r + x2i)
                  x0r = y1r + y5r
                  x0i = y1i + y5i
                  a(j1) = wk1r * x0r - wk1i * x0i
                  a(j1 + 1) = wk1r * x0i + wk1i * x0r
                  x0r = y1r - y5r
                  x0i = y1i - y5i
                  a(j5) = wk5r * x0r - wk5i * x0i
                  a(j5 + 1) = wk5r * x0i + wk5i * x0r
                  x0r = y3r - y7i
                  x0i = y3i + y7r
                  a(j3) = wk3r * x0r - wk3i * x0i
                  a(j3 + 1) = wk3r * x0i + wk3i * x0r
                  x0r = y3r + y7i
                  x0i = y3i - y7r
                  a(j7) = wk7r * x0r - wk7i * x0i
                  a(j7 + 1) = wk7r * x0i + wk7i * x0r
                  a(j) = y0r + y4r
                  a(j + 1) = y0i + y4i
                  x0r = y0r - y4r
                  x0i = y0i - y4i
                  a(j4) = wk4r * x0r - wk4i * x0i
                  a(j4 + 1) = wk4r * x0i + wk4i * x0r
                  x0r = y2r - y6i
                  x0i = y2i + y6r
                  a(j2) = wk2r * x0r - wk2i * x0i
                  a(j2 + 1) = wk2r * x0i + wk2i * x0r
                  x0r = y2r + y6i
                  x0i = y2i - y6r
                  a(j6) = wk6r * x0r - wk6i * x0i
                  a(j6 + 1) = wk6r * x0i + wk6i * x0r
              end do
          end do
      end if
      end
!
      subroutine rftfsub(n, a, nc, c)
      integer n, nc, j, k, kk, ks, m
      real*8 a(0 : n - 1), c(0 : nc - 1), wkr, wki, xr, xi, yr, yi
      m = n / 2
      ks = 2 * nc / m
      kk = 0
      do j = 2, m - 2, 2
          k = n - j
          kk = kk + ks
          wkr = 0.5d0 - c(nc - kk)
          wki = c(kk)
          xr = a(j) - a(k)
          xi = a(j + 1) + a(k + 1)
          yr = wkr * xr - wki * xi
          yi = wkr * xi + wki * xr
          a(j) = a(j) - yr
          a(j + 1) = a(j + 1) - yi
          a(k) = a(k) + yr
          a(k + 1) = a(k + 1) - yi
      end do
      end
!
      subroutine rftbsub(n, a, nc, c)
      integer n, nc, j, k, kk, ks, m
      real*8 a(0 : n - 1), c(0 : nc - 1), wkr, wki, xr, xi, yr, yi
      a(1) = -a(1)
      m = n / 2
      ks = 2 * nc / m
      kk = 0
      do j = 2, m - 2, 2
          k = n - j
          kk = kk + ks
          wkr = 0.5d0 - c(nc - kk)
          wki = c(kk)
          xr = a(j) - a(k)
          xi = a(j + 1) + a(k + 1)
          yr = wkr * xr + wki * xi
          yi = wkr * xi - wki * xr
          a(j) = a(j) - yr
          a(j + 1) = yi - a(j + 1)
          a(k) = a(k) + yr
          a(k + 1) = yi - a(k + 1)
      end do
      a(m + 1) = -a(m + 1)
      end
!
      subroutine dctsub(n, a, nc, c)
      integer n, nc, j, k, kk, ks, m
      real*8 a(0 : n - 1), c(0 : nc - 1), wkr, wki, xr
      m = n / 2
      ks = nc / n
      kk = 0
      do j = 1, m - 1
          k = n - j
          kk = kk + ks
          wkr = c(kk) - c(nc - kk)
          wki = c(kk) + c(nc - kk)
          xr = wki * a(j) - wkr * a(k)
          a(j) = wkr * a(j) + wki * a(k)
          a(k) = xr
      end do
      a(m) = c(0) * a(m)
      end
!
      subroutine dstsub(n, a, nc, c)
      integer n, nc, j, k, kk, ks, m
      real*8 a(0 : n - 1), c(0 : nc - 1), wkr, wki, xr
      m = n / 2
      ks = nc / n
      kk = 0
      do j = 1, m - 1
          k = n - j
          kk = kk + ks
          wkr = c(kk) - c(nc - kk)
          wki = c(kk) + c(nc - kk)
          xr = wki * a(k) - wkr * a(j)
          a(k) = wkr * a(k) + wki * a(j)
          a(j) = xr
      end do
      a(m) = c(0) * a(m)
      end
!
