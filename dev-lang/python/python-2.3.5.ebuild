# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/python/python-2.3.5.ebuild,v 1.9 2005/05/01 05:19:12 vapier Exp $

# NOTE about python-portage interactions :
# - Do not add a pkg_setup() check for a certain version of portage
#   in dev-lang/python. It _WILL_ stop people installing from
#   Gentoo 1.4 images.

inherit eutils flag-o-matic python

PYVER_MAJOR="`echo ${PV%_*} | cut -d '.' -f 1`"
PYVER_MINOR="`echo ${PV%_*} | cut -d '.' -f 2`"
PYVER="${PYVER_MAJOR}.${PYVER_MINOR}"

S="${WORKDIR}/Python-${PV}"
DESCRIPTION="A really great language"
HOMEPAGE="http://www.python.org/"
SRC_URI="http://www.python.org/ftp/python/${PV%_*}/Python-${PV}.tar.bz2"

LICENSE="PSF-2.2"
SLOT="2.3"
KEYWORDS="~alpha ~amd64 arm hppa ia64 ~mips ppc s390 sh sparc x86"
IUSE="ncurses gdbm ssl readline tcltk berkdb bootstrap ipv6 build ucs2 doc X"

DEPEND="virtual/libc
	>=sys-libs/zlib-1.1.3
	!build? (
		X? ( tcltk? ( >=dev-lang/tk-8.0 ) )
		ncurses? ( >=sys-libs/ncurses-5.2 readline? ( >=sys-libs/readline-4.1 ) )
		berkdb? ( >=sys-libs/db-3.1 )
		gdbm? ( sys-libs/gdbm )
		ssl? ( dev-libs/openssl )
		doc? ( =dev-python/python-docs-${PV}* )
		dev-libs/expat
	)"

# NOTE: The dev-python/python-fchksum RDEPEND is needed so that this python 
#       provides the functionality expected from previous pythons.

# NOTE: python-fchksum is only a RDEPEND and not a DEPEND since we don't need
#       it to compile python. We just need to ensure that when we install
#       python, we definitely have fchksum support. - liquidx

RDEPEND="${DEPEND} dev-python/python-fchksum"


PROVIDE="virtual/python"

src_unpack() {
	unpack ${A}
	cd ${S}

	# fix readline detection problems due to missing termcap (#79013)
	epatch ${FILESDIR}/${PN}-2.3-readline.patch

	sed -ie 's/OpenBSD\/3.\[01234/OpenBSD\/3.\[012345/' configure || die "OpenBSD sed failed"
	# adds /usr/lib/portage/pym to sys.path - liquidx (08 Oct 03)
	# prepends /usr/lib/portage/pym to sys.path - liquidx (12 Apr 04)
	epatch ${FILESDIR}/${PN}-2.3-add_portage_search_path_take_2.patch
	# adds support for PYTHON_DONTCOMPILE shell environment to
	# supress automatic generation of .pyc and .pyo files - liquidx (08 Oct 03)
	epatch ${FILESDIR}/${PN}-2.3-gentoo_py_dontcompile.patch
	epatch ${FILESDIR}/${PN}-2.3.2-disable_modules_and_ssl.patch
	epatch ${FILESDIR}/${PN}-2.3-mimetypes_apache.patch
	epatch ${FILESDIR}/${PN}-2.3-db4.2.patch

	# installs to lib64
	[ "$(get_libdir)" == "lib64" ] && epatch ${FILESDIR}/python-2.3.4-lib64.patch
	# fix os.utime() on hppa. utimes it not supported but unfortunately reported as working - gmsoft (22 May 04)
	[ "${ARCH}" = "hppa" ] && sed -e 's/utimes //' -i ${S}/configure
}

src_configure() {
	# disable extraneous modules with extra dependencies
	if use build; then
		export PYTHON_DISABLE_MODULES="readline pyexpat dbm gdbm bsddb _curses _curses_panel _tkinter"
		export PYTHON_DISABLE_SSL=1
	else
		use gdbm \
			|| PYTHON_DISABLE_MODULES="${PYTHON_DISABLE_MODULES} gdbm"
		use berkdb \
			|| PYTHON_DISABLE_MODULES="${PYTHON_DISABLE_MODULES} dbm bsddb"
		use readline \
			|| PYTHON_DISABLE_MODULES="${PYTHON_DISABLE_MODULES} readline"
		( use !X || use !tcltk ) \
			&& PYTHON_DISABLE_MODULES="${PYTHON_DISABLE_MODULES} _tkinter"
		use ncurses \
			|| PYTHON_DISABLE_MODULES="${PYTHON_DISABLE_MODULES} _curses _curses_panel"
		use ssl \
			|| export PYTHON_DISABLE_SSL=1
		export PYTHON_DISABLE_MODULES
		echo $PYTHON_DISABLE_MODULES
	fi
}

src_compile() {
	filter-flags -malign-double

	[ "${ARCH}" = "alpha" ] && append-flags -fPIC
	[ "${ARCH}" = "amd64" ] && append-flags -fPIC

	# http://bugs.gentoo.org/show_bug.cgi?id=50309
	if is-flag -O3; then
		is-flag -fstack-protector-all && replace-flags -O3 -O2
		use hardened && replace-flags -O3 -O2
	fi

	export OPT="${CFLAGS}"

	local myconf
	#if we are creating a new build image, we remove the dependency on g++
	if use build && ! use bootstrap; then
		myconf="--with-cxx=no"
	fi

	# super-secret switch. don't use this unless you know what you're
	# doing. enabling UCS2 support will break your existing python
	# modules
	use ucs2 \
		&& myconf="${myconf} --enable-unicode=ucs2" \
		|| myconf="${myconf} --enable-unicode=ucs4"

	src_configure

	econf --with-fpectl \
		--enable-shared \
		`use_enable ipv6` \
		--infodir='${prefix}'/share/info \
		--mandir='${prefix}'/share/man \
		--with-threads \
		${myconf} || die
	emake || die "Parallel make failed"
}

src_test() {
	local skip_tests="import sax"
	#Move known bad tests out of the way while we run good ones
	for test in ${skip_tests} ; do
		mv ${S}/Lib/test/test_${test}.py ${T}
	done

	make test || die "make test failed"

	#Move bad tests back so they get emerged
	for test in ${skip_tests} ; do
		mv ${T}/test_${test}.py ${S}/Lib/test/test_${test}.py
	done

	einfo "Portage skipped the following tests which aren't able to run from emerge:"
	for test in ${skip_tests} ; do
		einfo "test_${test}.py"
	done
	einfo "These tests normally pass when not run from emerge."
	einfo "If you'd like to run them, you may:"
	einfo "cd /usr/lib/python${PYVER}/test"
	einfo "and run the tests separately."
	einfo "See bug# 67970"
	ebeep 2
}


src_install() {
	dodir /usr
	src_configure
	make DESTDIR="${D}" altinstall  || die

	# install our own custom python-config
	exeinto /usr/bin
	newexe ${FILESDIR}/python-config-${PYVER} python-config

	# The stuff below this line extends from 2.1, and should be deprecated
	# in 2.3, or possibly can wait till 2.4

	# seems like the build do not install Makefile.pre.in anymore
	# it probably shouldn't - use DistUtils, people!
	insinto /usr/$(get_libdir)/python${PYVER}/config
	doins ${S}/Makefile.pre.in

	# While we're working on the config stuff... Let's fix the OPT var
	# so that it doesn't have any opts listed in it. Prevents the problem
	# with compiling things with conflicting opts later.
	dosed -e 's:^OPT=.*:OPT=-DNDEBUG:' /usr/$(get_libdir)/python${PYVER}/config/Makefile

	# install python-updater in /usr/sbin
	dosbin ${FILESDIR}/python-updater

	if use build ; then
		rm -rf ${D}/usr/$(get_libdir)/python2.3/{test,encodings,email,lib-tk,bsddb/test}
	else
		use uclibc && rm -rf ${D}/usr/$(get_libdir)/python2.3/{test,bsddb/test}
		use berkdb || rm -rf ${D}/usr/$(get_libdir)/python2.3/bsddb
		( use !X || use !tcltk ) && rm -rf ${D}/usr/$(get_libdir)/python2.3/lib-tk
	fi
}

pkg_postrm() {
	python_makesym
	python_mod_cleanup /usr/$(get_libdir)/python2.3
}

pkg_postinst() {
	local myroot
	myroot=$(echo $ROOT | sed 's:/$::')

	python_makesym
	python_mod_optimize
	python_mod_optimize -x site-packages -x test ${myroot}/usr/$(get_libdir)/python${PYVER}

	# workaround possible python-upgrade-breaks-portage situation
	if [ ! -f ${myroot}/usr/lib/portage/pym/portage.py ]; then
		if [ -f ${myroot}/usr/lib/python2.2/site-packages/portage.py ]; then
			einfo "Working around possible python-portage upgrade breakage"
			mkdir -p ${myroot}/usr/lib/portage/pym
			cp ${myroot}/usr/lib/python2.2/site-packages/{portage,xpak,output,cvstree,getbinpkg,emergehelp,dispatch_conf}.py ${myroot}/usr/lib/portage/pym
			python_mod_optimize ${myroot}/usr/lib/portage/pym
		fi
	fi

	echo
	ewarn
	ewarn "If you have just upgraded from python-2.2.x you will need to run:"
	ewarn
	ewarn "/usr/sbin/python-updater"
	ewarn
	ewarn "This will automatically rebuild all the python dependent modules"
	ewarn "to run with python-2.3."
	ewarn
	ewarn "Python 2.2 is still installed and can be accessed via /usr/bin/python2.2."
	ewarn "Portage-2.0.49-r8 and below will continue to use python-2.2.x, so"
	ewarn "think twice about uninstalling it, otherwise your system will break."
	ewarn
	ebeep 5
}
