# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/python/python-2.3.2-r1.ebuild,v 1.2 2003/10/08 15:49:37 liquidx Exp $

inherit flag-o-matic python

MY_PV=${PV/_rc/c}
PYVER_MAJOR="`echo ${PV%_*} | cut -d '.' -f 1`"
PYVER_MINOR="`echo ${PV%_*} | cut -d '.' -f 2`"
PYVER="${PYVER_MAJOR}.${PYVER_MINOR}"

S="${WORKDIR}/Python-${MY_PV}"
DESCRIPTION="A really great language"
SRC_URI="http://www.python.org/ftp/python/${PV%_*}/Python-${MY_PV}.tgz"
HOMEPAGE="http://www.python.org"

IUSE="readline tcltk berkdb bootstrap ipv6 cjk"
LICENSE="PSF-2.2"
SLOT="2.3"

KEYWORDS="~x86"
# "~ppc ~sparc ~alpha ~mips ~hppa ~arm"

DEPEND="virtual/glibc
	>=sys-libs/zlib-1.1.3
	readline? ( >=sys-libs/readline-4.1 >=sys-libs/ncurses-5.2 )
	berkdb? ( >=sys-libs/db-3 )
	tcltk? ( >=dev-lang/tk-8.0 )
	||	( dev-libs/expat
	     ( !build?     ( dev-libs/expat ) )
	     ( !bootstrap? ( dev-libs/expat ) )
		)"
# This is a hairy one.  Basically depend on dev-libs/expat
# if "build" or "bootstrap" not in USE.

RDEPEND="${DEPEND} dev-python/python-fchksum"

# The dev-python/python-fchksum RDEPEND is needed to that this python provides
# the functionality expected from previous pythons.

PROVIDE="virtual/python"


src_unpack() {
	unpack ${A}
	# adds /usr/lib/portage/pym to sys.path - liquidx (08 Oct 03)
	EPATCH_OPTS="-d ${S}" epatch ${FILESDIR}/${PN}-2.3-add_portage_search_path.patch
	# adds support for PYTHON_DONTCOMPILE shell environment to
	# supress automatic generation of .pyc and .pyo files - liquidx (08 Oct 03)
	EPATCH_OPTS="-d ${S}" epatch ${FILESDIR}/${PN}-2.3-gentoo_py_dontcompile.patch
}

src_compile() {
	filter-flags -malign-double

	[ "${ARCH}" = "hppa" ] && append-flags -fPIC
	[ "${ARCH}" = "alpha" ] && append-flags -fPIC
	export OPT="${CFLAGS}"

	local myconf
	#if we are creating a new build image, we remove the dependency on g++
	if [ "`use build`" -a ! "`use bootstrap`" ]
	then
		myconf="--with-cxx=no"
	fi

	# FIXME: (need to verify the consequences of this, probably breaks tkinter?)
	# use unicode ucs4 if cjk, otherwise use ucs2.
	use cjk \
		&& myconf="${myconf} --enable-unicode=ucs4" \
		|| myconf="${myconf} --enable-unicode=ucs2"

	econf --with-fpectl \
		--enable-shared \
		`use_enable ipv6` \
		--infodir='${prefix}'/share/info \
		--mandir='${prefix}'/share/man \
		--with-threads \
		${myconf} || die
	emake || die "Parallel make failed"
}

src_install() {
	dodir /usr
	make DESTDIR="${D}" altinstall  || die

	# install our own custom python-config
	exeinto /usr/bin
	newexe ${FILESDIR}/python-config-${PV} python-config

	# This stuff below extends from 2.1, and should be deprecated in 2.3,
	# or possibly can wait till 2.4

	# seems like the build do not install Makefile.pre.in anymore
	# it probably shouldn't - use DistUtils, people!
	insinto /usr/lib/python${PYVER}/config
	doins ${S}/Makefile.pre.in

	# While we're working on the config stuff... Let's fix the OPT var
	# so that it doesn't have any opts listed in it. Prevents the problem
	# with compiling things with conflicting opts later.
	dosed -e 's:^OPT=.*:OPT=-DNDEBUG:' /usr/lib/python${PYVER}/config/Makefile

}

pkg_postrm() {
	python_makesym
	python_mod_cleanup
}

pkg_postinst() {
	python_makesym
	python_mod_optimize

	echo
	ewarn
	ewarn "If you have just upgraded from python-2.2.x you will need to run:"
	ewarn
	ewarn "${PORTDIR}/dev-lang/python/files/python-updater"
	ewarn
	ewarn "This will automatically rebuild all the python dependent modules"
	ewarn "to run with python-2.3."
	ewarn
	ewarn "Python 2.2 is still installed and can be accessed via /usr/bin/python2.2."
	ewarn "Portage-2.0.49-r8 and below will continue to use python-2.2.x, so"
	ewarn "think twice about uninstalling it otherwise your system will break."
	ewarn
	echo -ne "\a"; sleep 1
	echo -ne "\a"; sleep 1
	echo -ne "\a"; sleep 1
	echo -ne "\a"; sleep 1
	echo -ne "\a"; sleep 1

}
