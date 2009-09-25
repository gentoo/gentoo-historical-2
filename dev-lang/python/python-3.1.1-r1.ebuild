# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/python/python-3.1.1-r1.ebuild,v 1.4 2009/09/25 17:20:04 zmedico Exp $

EAPI="2"

inherit autotools eutils flag-o-matic multilib pax-utils python toolchain-funcs versionator

# We need this so that we don't depend on python.eclass.
PYVER_MAJOR=$(get_major_version)
PYVER_MINOR=$(get_version_component_range 2)
PYVER="${PYVER_MAJOR}.${PYVER_MINOR}"

MY_P="Python-${PV}"
S="${WORKDIR}/${MY_P}"

PATCHSET_REVISION="2"

DESCRIPTION="Python is an interpreted, interactive, object-oriented programming language."
HOMEPAGE="http://www.python.org/"
SRC_URI="http://www.python.org/ftp/python/${PV}/${MY_P}.tar.bz2
	mirror://gentoo/python-gentoo-patches-${PV}$([[ "${PATCHSET_REVISION}" != "0" ]] && echo "-r${PATCHSET_REVISION}").tar.bz2"

LICENSE="PSF-2.2"
SLOT="3.1"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="build doc elibc_uclibc examples gdbm ipv6 ncurses readline sqlite ssl +threads tk ucs2 wininst +xml"

RDEPEND=">=app-admin/eselect-python-20080925
		>=sys-libs/zlib-1.1.3
		!build? (
			sqlite? ( >=dev-db/sqlite-3 )
			tk? ( >=dev-lang/tk-8.0 )
			ncurses? ( >=sys-libs/ncurses-5.2
						readline? ( >=sys-libs/readline-4.1 ) )
			gdbm? ( sys-libs/gdbm )
			ssl? ( dev-libs/openssl )
			doc? ( dev-python/python-docs:${SLOT} )
			xml? ( >=dev-libs/expat-2 )
		)
		!m68k? ( !mips? ( !sparc-fbsd? ( virtual/libffi ) ) )"
DEPEND="${RDEPEND}
		!m68k? ( !mips? ( !sparc-fbsd? ( dev-util/pkgconfig ) ) )"
PDEPEND="${RDEPEND} app-admin/python-updater"
RDEPEND+=" !build? ( app-misc/mime-types )"

PROVIDE="virtual/python"

src_prepare() {
	if ! tc-is-cross-compiler; then
		rm "${WORKDIR}/${PV}"/*_all_crosscompile.patch
	fi

	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/${PV}"

	sed -i -e "s:@@GENTOO_LIBDIR@@:$(get_libdir):g" \
		Lib/distutils/command/install.py \
		Lib/distutils/sysconfig.py \
		Lib/site.py \
		Makefile.pre.in \
		Modules/Setup.dist \
		Modules/getpath.c \
		setup.py || die "sed failed to replace @@GENTOO_LIBDIR@@"

	# Fix os.utime() on hppa. utimes it not supported but unfortunately reported as working - gmsoft (22 May 04)
	# PLEASE LEAVE THIS FIX FOR NEXT VERSIONS AS IT'S A CRITICAL FIX !!!
	[[ "${ARCH}" == "hppa" ]] && sed -e "s/utimes //" -i "${S}/configure"

	if ! use wininst; then
		# Remove Microsoft Windows executables.
		rm Lib/distutils/command/wininst-*.exe
	fi

	# Don't silence output of setup.py.
	sed -e '/setup\.py -q build/d' -i Makefile.pre.in

	# Fix OtherFileTests.testStdin() not to assume
	# that stdin is a tty for bug #248081.
	sed -e "s:'osf1V5':'osf1V5' and sys.stdin.isatty():" -i Lib/test/test_file.py || die "sed failed"

	eautoreconf
}

src_configure() {
	# Disable extraneous modules with extra dependencies.
	if use build; then
		export PYTHON_DISABLE_MODULES="gdbm _curses _curses_panel readline _sqlite3 _tkinter _elementtree pyexpat"
		export PYTHON_DISABLE_SSL="1"
	else
		local disable
		use gdbm     || disable+=" gdbm"
		use ncurses  || disable+=" _curses _curses_panel"
		use readline || disable+=" readline"
		use sqlite   || disable+=" _sqlite3"
		use ssl      || export PYTHON_DISABLE_SSL="1"
		use tk       || disable+=" _tkinter"
		use xml      || disable+=" _elementtree pyexpat" # _elementtree uses pyexpat.
		export PYTHON_DISABLE_MODULES="${disable}"

		if ! use xml; then
			ewarn "You have configured Python without XML support."
			ewarn "This is NOT a recommended configuration as you"
			ewarn "may face problems parsing any XML documents."
		fi
	fi

	if [[ -n "${PYTHON_DISABLE_MODULES}" ]]; then
		einfo "Disabled modules: ${PYTHON_DISABLE_MODULES}"
	fi

	export OPT="${CFLAGS}"

	local myconf

	filter-flags -malign-double

	[[ "${ARCH}" == "alpha" ]] && append-flags -fPIC

	# https://bugs.gentoo.org/show_bug.cgi?id=50309
	if is-flag -O3; then
		is-flag -fstack-protector-all && replace-flags -O3 -O2
		use hardened && replace-flags -O3 -O2
	fi

	if tc-is-cross-compiler; then
		OPT="-O1" CFLAGS="" LDFLAGS="" CC="" \
		./configure --{build,host}=${CBUILD} || die "cross-configure failed"
		emake python Parser/pgen || die "cross-make failed"
		mv python hostpython
		mv Parser/pgen Parser/hostpgen
		make distclean
		sed -i \
			-e "/^HOSTPYTHON/s:=.*:=./hostpython:" \
			-e "/^HOSTPGEN/s:=.*:=./Parser/hostpgen:" \
			Makefile.pre.in || die "sed failed"
	fi

	# Export CXX so it ends up in /usr/lib/python3.X/config/Makefile.
	tc-export CXX

	# Set LDFLAGS so we link modules with -lpython3.1 correctly.
	# Needed on FreeBSD unless Python 3.1 is already installed.
	# Please query BSD team before removing this!
	append-ldflags "-L."

	local dbmliborder
	if use gdbm; then
		dbmliborder+=":gdbm"
	fi
	dbmliborder="${dbmliborder#:}"

	if ! use m68k && ! use mips && ! use sparc-fbsd; then
		myconf+=" --with-system-ffi"
	fi

	econf \
		--with-fpectl \
		--enable-shared \
		$(use_enable ipv6) \
		$(use_with threads) \
		$(use_with !ucs2 wide-unicode) \
		--infodir='${prefix}'/share/info \
		--mandir='${prefix}'/share/man \
		--with-libc='' \
		--with-dbmliborder=${dbmliborder} \
		${myconf}
}

src_test() {
	# Tests won't work when cross compiling.
	if tc-is-cross-compiler; then
		elog "Disabling tests due to crosscompiling."
		return
	fi

	# Byte compiling should be enabled here.
	# Otherwise test_import fails.
	python_enable_pyc

	# Skip all tests that fail during emerge but pass without emerge:
	# (See bug #67970)
	local skip_tests="distutils"

	# test_debuglevel from test_telnetlib.py fails sometimes with
	# socket.error: [Errno 104] Connection reset by peer
	skip_tests+=" telnetlib"

	# test_ctypes fails with PAX kernel (bug #234498).
	host-is-pax && skip_tests+=" ctypes"

	for test in ${skip_tests}; do
		mv "${S}"/Lib/test/test_${test}.py "${T}"
	done

	# Rerun failed tests in verbose mode (regrtest -w).
	EXTRATESTOPTS="-w" make test || die "make test failed"

	for test in ${skip_tests}; do
		mv "${T}"/test_${test}.py "${S}"/Lib/test/test_${test}.py
	done

	elog "The following tests have been skipped:"
	for test in ${skip_tests}; do
		elog "test_${test}.py"
	done

	elog "If you'd like to run them, you may:"
	elog "cd /usr/$(get_libdir)/python${PYVER}/test"
	elog "and run the tests separately."
}

src_install() {
	emake DESTDIR="${D}" altinstall || die "emake altinstall failed"

	mv "${D}usr/bin/python${PYVER}-config" "${D}usr/bin/python-config-${PYVER}"

	# Fix collisions between different slots of Python.
	mv "${D}usr/bin/2to3" "${D}usr/bin/2to3-${PYVER}"
	mv "${D}usr/bin/pydoc3" "${D}usr/bin/pydoc${PYVER}"
	mv "${D}usr/bin/idle3" "${D}usr/bin/idle${PYVER}"
	rm -f "${D}usr/bin/smtpd.py"

	# Fix the OPT variable so that it doesn't have any flags listed in it.
	# Prevents the problem with compiling things with conflicting flags later.
	sed -e "s:^OPT=.*:OPT=-DNDEBUG:" -i "${D}usr/$(get_libdir)/python${PYVER}/config/Makefile"

	if use build; then
		rm -fr "${D}usr/$(get_libdir)/python${PYVER}/"{email,sqlite3,test,tkinter}
	else
		use elibc_uclibc && rm -fr "${D}usr/$(get_libdir)/python${PYVER}/test"
		use sqlite || rm -fr "${D}usr/$(get_libdir)/python${PYVER}/"{sqlite3,test/test_sqlite*}
		use tk || rm -fr "${D}usr/$(get_libdir)/python${PYVER}/"{tkinter,test/test_tk*}
	fi

	use threads || rm -fr "${D}usr/$(get_libdir)/python${PYVER}/multiprocessing"

	prep_ml_includes usr/include/python${PYVER}

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${S}"/Tools || die "doins failed"
	fi

	newinitd "${FILESDIR}/pydoc.init" pydoc-${SLOT}
	newconfd "${FILESDIR}/pydoc.conf" pydoc-${SLOT}
}

pkg_postinst() {
	# Update symlink temporarily for byte-compiling.
	eselect python update

	python_mod_optimize -x "(site-packages|test)" /usr/lib/python${PYVER}
	[[ "$(get_libdir)" != "lib" ]] && python_mod_optimize -x "(site-packages|test)" /usr/$(get_libdir)/python${PYVER}

	# Update symlink back to old version.
	# Remove this after testing is done.
	eselect python update --ignore 3.0 --ignore 3.1 --ignore 3.2

	ewarn
	ewarn "WARNING!"
	ewarn "Many Python modules haven't been ported yet to Python 3.*."
	ewarn "Python 3 hasn't been activated and Python wrapper is still configured to use Python 2."
	ewarn
	ebeep
}

pkg_postrm() {
	eselect python update --ignore 3.0 --ignore 3.1 --ignore 3.2

	python_mod_cleanup /usr/lib/python${PYVER}
	[[ "$(get_libdir)" != "lib" ]] && python_mod_cleanup /usr/$(get_libdir)/python${PYVER}
}
