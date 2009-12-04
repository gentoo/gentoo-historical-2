# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/mpich2/mpich2-1.2.1.ebuild,v 1.1 2009/12/04 16:50:06 jsbronder Exp $

EAPI=1
inherit eutils fortran
MY_PV=${PV/_/}
DESCRIPTION="MPICH2 - A portable MPI implementation"
HOMEPAGE="http://www.mcs.anl.gov/research/projects/mpich2/index.php"
SRC_URI="http://www.mcs.anl.gov/research/projects/mpich2/downloads/tarballs/${MY_PV}/${PN}-${MY_PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="+cxx debug doc fortran pvfs2 threads romio mpi-threads"

COMMON_DEPEND="dev-lang/perl
	>=dev-lang/python-2.3
	romio? ( net-fs/nfs-utils )
	pvfs2? ( >=sys-cluster/pvfs2-2.7.0 )
	dev-libs/libaio
	!media-sound/mpd
	!sys-cluster/mpiexec
	!sys-cluster/openmpi
	!sys-cluster/lam-mpi
	!sys-cluster/mpich"

DEPEND="${COMMON_DEPEND}
	sys-devel/libtool"

RDEPEND="${COMMON_DEPEND}
	net-misc/openssh"

S="${WORKDIR}"/${PN}-${MY_PV}

pkg_setup() {
	if [ -n "${MPICH_CONFIGURE_OPTS}" ]; then
	    elog "User-specified configure options are ${MPICH_CONFIGURE_OPTS}."
	else
	    elog "User-specified configure options are not set."
	    elog "If needed, see the docs and set MPICH_CONFIGURE_OPTS."
	fi

	if use fortran ; then
		FORTRAN="g77 gfortran ifort ifc"
		fortran_pkg_setup
	fi

	if use mpi-threads && ! use threads; then
		die "USE=mpi-threads requires USE=threads"
	fi

	MPD_CONF_FILE_DIR=/etc/${PN}
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Upstream trunk, r5843
	epatch "${FILESDIR}"/0001-MPD_CONF_FILE-should-be-readable.patch
	# Upstream trunk, r5844
	epatch "${FILESDIR}"/0002-mpd_conf_file-search-order.patch
	# Upstream trunk, r5845
	epatch "${FILESDIR}"/0003-Fix-pkgconfig-for-mpich2-ch3-v1.2.1.patch

	# We need f90 to include the directory with mods, and to
	# fix hardcoded paths for src_test()
	sed -i \
		-e "s,F90FLAGS\( *\)=,F90FLAGS\1?=," \
		-e "s,\$(bindir)/,${S}/bin/,g" \
		-e "s,@MPIEXEC@,${S}/bin/mpiexec,g" \
		$(find ./test/ -name 'Makefile.in') || die

	if ! use romio; then
		# These tests in errhan/ rely on MPI::File ...which is in romio
		echo "" > test/mpi/errors/cxx/errhan/testlist
	fi
}

src_compile() {
	local c="${MPICH_CONFIGURE_OPTS} --enable-sharedlibs=gcc"
	local romio_conf

	# The configure statements can be somewhat confusing, as they
	# don't all show up in the top level configure, however, they
	# are picked up in the children directories.

	use debug && c="${c} --enable-g=all --enable-debuginfo"

	if use threads ; then
	    c="${c} --with-thread-package=pthreads"
	else
	    c="${c} --with-thread-package=none"
	fi

	# enable f90 support for appropriate compilers
	case "${FORTRANC}" in
	    gfortran|if*)
			c="${c} --enable-f77 --enable-f90";;
	    g77)
			c="${c} --enable-f77 --disable-f90";;
	esac

	if use mpi-threads; then
		c="${c} --enable-threads=default"
	else
		c="${c} --enable-threads=single"
	fi

	if use pvfs2; then
		# nfs and ufs are defaults in 1.0.8 at least.
	    romio_conf="--with-file-system=pvfs2+nfs+ufs --with-pvfs2=/usr"
	fi

	c="${c} --sysconfdir=/etc/${PN}"
	econf ${c} ${romio_conf} \
		--docdir=/usr/share/doc/${PF} \
		--with-pm=mpd:gforker \
		--disable-mpe \
		$(use_enable romio) \
		$(use_enable cxx) \
		|| die
	# Oh, the irony.
	# http://wiki.mcs.anl.gov/mpich2/index.php/Frequently_Asked_Questions#Q:_The_build_fails_when_I_use_parallel_make.
	# https://trac.mcs.anl.gov/projects/mpich2/ticket/297
	emake -j1 || die
}

src_test() {
	local rc

	cp "${FILESDIR}"/mpd.conf "${T}"/mpd.conf || die
	chmod 600 "${T}"/mpd.conf
	export MPD_CONF_FILE="${T}/mpd.conf"
	"${S}"/bin/mpd --daemon --pid="${T}"/mpd.pid

	make \
		CC="${S}"/bin/mpicc \
		CXX="${S}"/bin/mpicxx \
		FC="${S}"/bin/mpif77 \
		F90="${S}"/bin/mpif90 \
		F90FLAGS="${F90FLAGS} -I${S}/src/binding/f90/" \
		testing
	rc=$?

	"${S}"/bin/mpdallexit || kill $(<"${T}"/mpd.pid)
	return ${rc}
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodir ${MPD_CONF_FILE_DIR}
	insinto ${MPD_CONF_FILE_DIR}
	doins "${FILESDIR}"/mpd.conf || die

	dodir /usr/share/doc/${PF}
	dodoc COPYRIGHT README CHANGES RELEASE_NOTES || die
	newdoc src/pm/mpd/README README.mpd || die
	if use romio; then
		newdoc src/mpi/romio/README README.romio || die
	fi

	if ! use doc; then
		rm -rf "${D}"/usr/share/doc/www*
	else
		dodir /usr/share/doc/${PF}/www
		mv "${D}"/usr/share/doc/www*/* "${D}"/usr/share/doc/${PF}/www/
	fi
}

pkg_postinst() {
	# Here so we can play with ebuild commands as a normal user
	chown root:root "${ROOT}"${MPD_CONF_FILE_DIR}/mpd.conf
	chmod 600 "${ROOT}"${MPD_CONF_FILE_DIR}/mpd.conf

	elog ""
	elog "MPE2 has been removed from this ebuild and now stands alone"
	elog "as sys-cluster/mpe2."
	elog ""
}
