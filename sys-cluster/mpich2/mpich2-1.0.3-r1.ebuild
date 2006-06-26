# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/mpich2/mpich2-1.0.3-r1.ebuild,v 1.1 2006/06/26 06:15:00 nerdboy Exp $

inherit fortran distutils eutils autotools kde-functions toolchain-funcs

DESCRIPTION="MPICH2 - A portable MPI implementation"
HOMEPAGE="http://www-unix.mcs.anl.gov/mpi/mpich2"
SRC_URI="ftp://ftp.mcs.anl.gov/pub/mpi/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
# need more arches in here, like sparc...
IUSE="crypt cxx doc debug fortran mpe mpe-sdk threads"

PROVIDE="virtual/mpi"
DEPEND="virtual/libc
	sys-devel/autoconf
	sys-devel/automake
	sys-devel/libtool
	sys-apps/coreutils
	dev-lang/perl
	sys-devel/gcc
	mpe-sdk? ( >=virtual/jdk-1.4.2 )
	>=dev-lang/python-2.3"
RDEPEND="${DEPEND}
	crypt? ( net-misc/openssh )
	!crypt? ( net-misc/netkit-rsh )
	!virtual/mpi"

RESTRICT="test"

pkg_setup() {
	if [ -n "${MPICH_CONFIGURE_OPTS}" ]; then
		einfo "Custom configure options are ${MPICH_CONFIGURE_OPTS}."
	fi
	if use fortran ; then
	    if [ $(gcc-major-version) -ge 4 ] \
		&& built_with_use sys-devel/gcc fortran ; then
		    FORTRAN="gfortran"
		    fortran_pkg_setup
	    else
		ewarn "You need gcc-4 built with fortran support in order to"
		ewarn "build the f90 mpi interface, which is required for f90"
		ewarn "and mpi support in hdf5 (for example)."
	    fi
	else
	    einfo "Unless you have another f90 compiler installed, we can only"
	    einfo "build the f77 and C++ interfaces with gcc-3.x"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
	need-autoconf 2.5
	epatch ${FILESDIR}/${P}-soname.patch || die "soname patch failed"
	ebegin "Reconfiguring"
	    find . -name configure -print | xargs rm
	    ./maint/updatefiles
	    use mpe-sdk && ./src/mpe2/maint/updatefiles
	eend
	epatch ${FILESDIR}/${P}-make.patch || die "make patch failed"
	#epatch ${FILESDIR}/${P}-make-test.patch || die "make test patch failed"
	echo "LDPATH=\"/usr/$(get_libdir)/${PN}\"" > 42mpich2
}

src_compile() {
	export LDFLAGS='-Wl,-z,now'
	local RSHCOMMAND

	if use crypt ; then
		RSHCOMMAND="ssh -x"
	else
		RSHCOMMAND="rsh"
	fi
	export RSHCOMMAND

	local myconf="${MPICH_CONFIGURE_OPTS}"

	if ! use debug ; then
	    myconf="${myconf} --enable-fast --enable-g=none"
	else
	    myconf="${myconf} --enable-g=dbg --enable-debuginfo"
	fi

	if ! use mpe-sdk ; then
	    myconf="${myconf} --enable-graphics=no --enable-rlog=no \
		--enable-clog=no --enable-slog2=no"
	fi
	use mpe && MPE_SRC_DIR=${S}/src/mpe2

	./configure --prefix=/usr --exec-prefix=/usr \
		--enable-sharedlibs=gcc \
		${myconf} \
		$(use_enable cxx) \
		$(use_enable mpe) \
		$(use_enable threads) \
		--includedir=/usr/include \
		--libdir=/usr/$(get_libdir)/${PN} \
		--mandir=/usr/share/man \
		--with-docdir=/usr/share/doc/${PF} \
		--with-htmldir=/usr/share/doc/${PF}/html \
		--sysconfdir=/etc/${PN} \
		--datadir=/usr/share/${PN} || die "configure failed"

	if use mpe-sdk ; then
	    ${MPE_SRC_DIR}/configure --prefix=/usr --enable-mpich \
		--with-mpicc=mpicc --with-mpif77=mpif77 --enable-wrappers \
		--enable-collchk --with-flib_path_leader="-Wl,-L"
	fi

	if use mpe ; then
	     epatch ${FILESDIR}/${P}-mpe-install.patch || die "install patch failed"
	fi

	# parallel makes are currently broken, so no emake...
	make dependencies
	make || die "make failed"

	if has test ${FEATURES} ; then
	    # get setup for src_test
	    export LDFLAGS='-L../../lib'
	    cd ${S}/test/mpi
	    #make clean || die "make clean failed"
	    echo
	    einfo "Using ./configure --prefix=${S} --with-mpi=${S} --disable-f90"
	    echo
	    ./configure --prefix=${S} --with-mpi=${S} $(use_enable threads) \
	        --exec-prefix=${S} --includedir=${S}/src/include --disable-f90 \
		|| die "configure test failed"
	    make dependencies
	    # make doesn't work here for some reason, although it works fine
	    # when run manually.  Go figure...
	    #cd ${S}/test/mpi/util
	    #make all || die "make util failed"
	    cd ${S}/test
	    install -g portage -o portage -m 0600 ${FILESDIR}/mpd.conf ${HOME}/.mpd.conf
	    #${S}/bin/mpd --daemon
	    make all || die "make pre-test failed"
	    #cd ${S}/test/mpi
	    #make || die "make test failed"
	    #${S}/bin/mpdallexit
	fi
}

src_test() {
	ewarn "Tests can take a long time to complete, even on a fast box."
	ewarn "Expected result on amd64 with gcc 4.1.1:"
	ewarn "     6 tests failed out of 373"
	echo
	einfo "Control-C now if you want to disable tests..."
	epause

	${S}/bin/mpd --daemon
	cd ${S}/test
	nice --adjustment=3 make testing || die "run tests failed"
	${S}/bin/mpdallexit
}

src_install() {
	dodir /etc/${PN}
	rm -rf src/mpe2/etc/*.in
	make install DESTDIR=${D} \
	    LIBDIR=${D}usr/$(get_libdir)/${PN} || die "make install failed"

	dodir /usr/share/${PN}
	mv ${D}usr/examples/cpi ${D}usr/share/${PN}/cpi
	rm -rf ${D}usr/examples
	rm -rf ${D}usr/sbin

	dodir /usr/share/doc/${PF}
	if use doc; then
		dodoc COPYRIGHT README README.romio README.testing CHANGES
		dodoc README.developer RELEASE_NOTES
		newdoc src/pm/mpd/README README.mpd
	else
		rm -rf ${D}usr/share/doc/
		rm -rf ${D}usr/share/man/
		dodoc README CHANGES COPYRIGHT RELEASE_NOTES
	fi
	doenvd 42mpich2
}

pkg_postinst() {
	python_version
	python_mod_optimize ${ROOT}usr/bin
	echo
	einfo "Note: this package still needs testing with other Fortran90"
	einfo "compilers besides gfortran (gcc4).  The tests also need some"
	einfo "magic to build properly within the portage build environment."
	einfo "(currently the tests only build and run manually)"
	echo
	einfo "The gfortran support has been tested successfully with hdf5"
	einfo "(using gfortran and the mpif90 wrapper)."
}

pkg_postrm() {
	python_version
	python_mod_cleanup
}
