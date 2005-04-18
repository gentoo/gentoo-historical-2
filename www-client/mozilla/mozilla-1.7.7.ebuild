# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/mozilla/mozilla-1.7.7.ebuild,v 1.6 2005/04/18 18:00:38 kloeri Exp $

unset ALLOWED_FLAGS  # stupid extra-functions.sh ... bug 49179
inherit flag-o-matic gcc eutils nsplugins mozilla-launcher mozconfig makeedit multilib

IUSE="java crypt ssl moznomail postgres"

EMVER="0.91.0"
IPCVER="1.1.2"

# handle _rc versions
MY_PV=${PV/_alpha/a} 	# handle alpha
MY_PV=${MY_PV/_beta/b}	# handle beta
MY_PV=${MY_PV/_rc/rc}	# handle rc

DESCRIPTION="Mozilla Application Suite - web browser, email, HTML editor, IRC"
HOMEPAGE="http://www.mozilla.org"
SRC_URI="http://ftp.mozilla.org/pub/mozilla.org/mozilla/releases/${PN}${MY_PV}/source/${PN}-source-${MY_PV}.tar.bz2
	crypt? ( !moznomail? (
		http://www.mozilla-enigmail.org/downloads/src/ipc-${IPCVER}.tar.gz
		http://www.mozilla-enigmail.org/downloads/src/enigmail-${EMVER}.tar.gz
	) )"

KEYWORDS="alpha amd64 hppa ~ia64 ppc sparc x86"
SLOT="0"
LICENSE="MPL-1.1 NPL-1.1"

# xrender.pc appeared for the first time in xorg-x11-6.7.0-r2
# and is required to build with support for cairo.  #71504
RDEPEND="java? ( virtual/jre )
	mozsvg? (
		>=x11-base/xorg-x11-6.7.0-r2
		x11-libs/cairo
	)
	crypt? ( !moznomail? ( >=app-crypt/gnupg-1.2.1 ) )
	>=www-client/mozilla-launcher-1.28"

DEPEND="${RDEPEND}
	~sys-devel/autoconf-2.13
	java? ( >=dev-java/java-config-0.2.0 )
	dev-lang/perl
	pgsql? ( >=dev-db/postgresql-7.2.0 )"

S="${WORKDIR}/mozilla"

src_unpack() {
	typeset x

	unpack ${A} || die "unpack failed"
	cd ${S} || die "cd failed"

	if [[ $(gcc-major-version) -eq 3 ]]; then
		# ABI Patch for alpha/xpcom for gcc-3.x
		if [[ ${ARCH} == alpha ]]; then
			epatch ${FILESDIR}/${PN}-alpha-xpcom-subs-fix.patch
		fi
	fi

	# Fix stack growth logic
	epatch ${FILESDIR}/${PN}-stackgrowth.patch

	# Fix logic error when using RAW target
	# <azarah@gentoo.org> (23 Feb 2003)
	epatch ${FILESDIR}/1.3/${PN}-1.3-fix-RAW-target.patch

	# HPPA patches from Ivar <orskaug@stud.ntnu.no>
	# <gmsoft@gentoo.org> (22 Dec 2004)
	epatch ${FILESDIR}/mozilla-hppa.patch

	# patch out ft caching code since the API changed between releases of
	# freetype; this enables freetype-2.1.8+ compat.
	# https://bugzilla.mozilla.org/show_bug.cgi?id=234035#c65
	epatch ${FILESDIR}/mozilla-1.7.3-4ft2.patch

	# Patch for newer versions of cairo ( bug #80301) 
	if has_version '>=x11-libs/cairo-0.3.0'; then
		epatch ${FILESDIR}/svg-cairo-0.3.0-fix.patch
	fi

	# Fix scripts that call for /usr/local/bin/perl #51916
	ebegin "Patching smime to call perl from /usr/bin"
	sed -i -e '1s,usr/local/bin,usr/bin,' security/nss/cmd/smimetools/smime
	eend || die "sed failed"

	WANT_AUTOCONF=2.1 autoconf || die "WANT_AUTOCONF failed"

	# Unpack the enigmail plugin
	if use crypt && ! use moznomail; then
		for x in ipc enigmail; do
			mv ${WORKDIR}/${x} ${S}/extensions || die "mv failed"
			cd ${S}/extensions/${x} || die "cd failed"
			makemake	# from mozilla.eclass
		done
	fi
}

src_compile() {
	####################################
	#
	# mozconfig, CFLAGS and CXXFLAGS setup
	#
	####################################

	mozconfig_init

	# Bug 60668: Galeon doesn't build without oji enabled, so enable it
	# regardless of java setting.
	mozconfig_annotate '' --enable-oji --enable-mathml

	# Other moz-specific settings
	mozconfig_use_enable mozdevelop jsd
	mozconfig_use_enable mozdevelop xpctools
	mozconfig_use_extension mozdevelop venkman
	mozconfig_use_enable gnome gnomevfs
	mozconfig_use_extension gnome gnomevfs
	mozconfig_use_extension !moznoirc irc
	mozconfig_use_extension mozxmlterm xmlterm
	mozconfig_use_extension postgres sql
	mozconfig_use_enable mozcalendar calendar
	mozconfig_use_enable ldap
	mozconfig_use_enable ldap ldap-experimental
	mozconfig_use_enable mozsvg svg
	mozconfig_use_enable mozsvg svg-renderer-cairo
	mozconfig_annotate '' --prefix=/usr/$(get_libdir)/mozilla
	mozconfig_annotate '' --with-default-mozilla-five-home=/usr/$(get_libdir)/mozilla

	if use moznomail && ! use mozcalendar; then
		mozconfig_annotate "+moznomail -mozcalendar" --disable-mailnews
	fi
	if use moznocompose && use moznomail; then
		mozconfig_annotate "+moznocompose +moznomail" --disable-composer
	fi

	# Finalize and report settings
	mozconfig_final

	if use postgres ; then
		export MOZ_ENABLE_PGSQL=1
		export MOZ_PGSQL_INCLUDES=/usr/include
		export MOZ_PGSQL_LIBS=/usr/$(get_libdir)
	fi

	####################################
	#
	#  Configure and build Mozilla
	#
	####################################

	# ./configure picks up the mozconfig stuff
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getLD)" \
	./configure || die "configure failed"

	# This removes extraneous CFLAGS from the Makefiles to reduce RAM
	# requirements while compiling
	edit_makefiles

	emake || die "emake failed"

	####################################
	#
	#  Build Mozilla NSS
	#
	####################################

	# Build the NSS/SSL support
	if use ssl; then
		einfo "Building Mozilla NSS..."

		# Fix #include problem
		cd ${S}/security/coreconf || die "cd coreconf failed"
		echo 'INCLUDES += -I$(DIST)/include/nspr -I$(DIST)/include/dbm'\
			>>headers.mk
		emake -j1 || die "make security headers failed"

		cd ${S}/security/nss || die "cd nss failed"
		emake -j1 moz_import || die "make moz_import failed"
		emake -j1 || die "make nss failed"
	fi

	####################################
	#
	#  Build Enigmail plugin
	#
	####################################

	# Build the enigmail plugin
	if use crypt && ! use moznomail; then
		einfo "Building Enigmail plugin..."
		cd ${S}/extensions/ipc || die "cd ipc failed"
		emake || die "make ipc failed"

		cd ${S}/extensions/enigmail || die "cd enigmail failed"
		emake || die "make enigmail failed"
	fi
}

src_install() {
	# Install, don't create tarball
	dodir /usr/$(get_libdir)
	cd ${S}/xpinstall/packager
	einfo "Installing mozilla into build root..."
	make MOZ_PKG_FORMAT="RAW" TAR_CREATE_FLAGS="-chf" > /dev/null || die "make failed"
	mv -f ${S}/dist/mozilla ${D}/usr/$(get_libdir)/mozilla

	einfo "Installing includes and idl files..."
	# Copy the include and idl files
	dodir /usr/$(get_libdir)/mozilla/include/idl /usr/include
	cd ${S}/dist
	cp -LfR include/* ${D}/usr/$(get_libdir)/mozilla/include
	cp -LfR idl/* ${D}/usr/$(get_libdir)/mozilla/include/idl
	dosym /usr/$(get_libdir)/mozilla/include /usr/include/mozilla

	# Install the development tools in /usr
	dodir /usr/bin
	mv ${D}/usr/$(get_libdir)/mozilla/{xpcshell,xpidl,xpt_dump,xpt_link} ${D}/usr/bin

	# Install the NSS/SSL libs, headers and tools
	if use ssl; then
		einfo "Installing Mozilla NSS..."
		# Install the headers ('make install' do not work for headers ...)
		insinto /usr/$(get_libdir)/mozilla/include/nss
		[ -d ${S}/dist/public/nss ] && doins ${S}/dist/public/nss/*.h
		[ -d ${S}/dist/public/seccmd ] && doins ${S}/dist/public/seccmd/*.h
		[ -d ${S}/dist/public/security ] && doins ${S}/dist/public/security/*.h
		# These come with zlib ...
		rm -f ${D}/usr/$(get_libdir)/mozilla/include/nss/{zconf.h,zlib.h}

		cd ${S}/security/nss

		mkdir -p ${WORKDIR}/nss/{bin,lib}
		export SOURCE_BIN_DIR=${WORKDIR}/nss/bin
		export SOURCE_LIB_DIR=${WORKDIR}/nss/lib

		make install || die "make failed"
		# Gets installed as symbolic links ...
		cp -Lf ${WORKDIR}/nss/bin/* ${D}/usr/bin
		cp -Lf ${WORKDIR}/nss/lib/* ${D}/usr/$(get_libdir)/mozilla

		# Need to unset these incase we want to rebuild, else the build
		# gets newked.
		unset SOURCE_LIB_DIR
		unset SOURCE_BIN_DIR
	fi

	cd ${S}/build/unix
	# Fix mozilla-config and install it
	perl -pi -e "s:/lib/mozilla-${MY_PV}::g" mozilla-config
	perl -pi -e "s:/mozilla-${MY_PV}::g" mozilla-config
	exeinto /usr/$(get_libdir)/mozilla
	doexe mozilla-config
	# Fix pkgconfig files and install them
	insinto /usr/$(get_libdir)/pkgconfig
	for x in *.pc; do
		if [[ -f ${x} ]]; then
			perl -pi -e "s:/lib/mozilla-${MY_PV}::g" ${x}
			perl -pi -e "s:/mozilla-${MY_PV}::g" ${x}
			doins ${x}
		fi
	done
	cd ${S}

	dodir /usr/bin
	cat <<EOF >${D}/usr/bin/mozilla
#!/bin/sh
# 
# Stub script to run mozilla-launcher.  We used to use a symlink here but
# OOo brokenness makes it necessary to use a stub instead:
# http://bugs.gentoo.org/show_bug.cgi?id=78890

export MOZILLA_LAUNCHER=mozilla
exec /usr/libexec/mozilla-launcher "\$@"
EOF
	chmod 0755 ${D}/usr/bin/mozilla
	insinto /etc/env.d
	doins ${FILESDIR}/10mozilla
	dodoc LEGAL LICENSE README/mozilla/README*

	# Install rebuild script
	exeinto /usr/$(get_libdir)/mozilla/
	doexe ${FILESDIR}/mozilla-rebuild-databases.pl

	# Move plugins dir
	src_mv_plugins /usr/$(get_libdir)/mozilla/plugins

	# Update Google search plugin to use UTF8 charset ...
	insinto /usr/$(get_libdir)/mozilla/searchplugins
	doins ${FILESDIR}/google.src

	if [[ -f "${WORKDIR}/.xft" ]]; then
		# We are using Xft, so change the default font
		insinto /usr/$(get_libdir)/mozilla/defaults/pref
		doins ${FILESDIR}/xft.js
	fi

	# Fix icons to look the same everywhere
	insinto /usr/$(get_libdir)/mozilla/icons
	doins ${S}/widget/src/gtk/mozicon16.xpm
	doins ${S}/widget/src/gtk/mozicon50.xpm

	# Install icon and .desktop for menu entry
	insinto /usr/share/pixmaps
	doins ${FILESDIR}/icon/mozilla-icon.png
	insinto /usr/share/applications
	doins ${FILESDIR}/icon/mozilla.desktop

	# Take care of non root execution
	# (seems the problem is that not all files are readible by the user)
	einfo "Fixing Permissions..."
	chmod -R g+r,o+r ${D}/usr/$(get_libdir)/mozilla
	find ${D}/usr/$(get_libdir)/mozilla/ -type d -exec chmod 0755 {} \; || :
}

pkg_preinst() {
	# Move old plugins dir
	pkg_mv_plugins /usr/$(get_libdir)/mozilla/plugins

	if true; then
		# Remove entire installed instance to solve various problems,
		# for example see bug 27719
		rm -rf ${ROOT}/usr/$(get_libdir)/mozilla
	else
		# Stale components and chrome files break when unmerging old
		rm -rf ${ROOT}/usr/$(get_libdir)/mozilla/components
		rm -rf ${ROOT}/usr/$(get_libdir)/mozilla/chrome

		# Remove stale component registry.
		rm -f ${ROOT}/usr/$(get_libdir)/mozilla/component.reg
		rm -f ${ROOT}/usr/$(get_libdir)/mozilla/components/compreg.dat

		# Make sure these are removed.
		rm -f ${ROOT}/usr/$(get_libdir)/mozilla/lib{Xft,Xrender}.so*
	fi
}

pkg_postinst() {
	export MOZILLA_FIVE_HOME="${ROOT}/usr/$(get_libdir)/mozilla"

	# Needed to update the run time bindings for REGXPCOM
	# (do not remove next line!)
	env-update

	# Register Components and Chrome
	einfo "Registering Components and Chrome..."
	${MOZILLA_FIVE_HOME}/mozilla-rebuild-databases.pl

	# Fix permissions of component registry
	chmod 0644 ${MOZILLA_FIVE_HOME}/components/compreg.dat

	# Fix directory permissions
	find ${MOZILLA_FIVE_HOME}/ -type d -perm 0700 -exec chmod 0755 {} \;

	# Fix permissions on chrome files
	find ${MOZILLA_FIVE_HOME}/chrome/ -name '*.rdf' -exec chmod 0644 {} \;

	update_mozilla_launcher_symlinks
}

pkg_postrm() {
	# Regenerate component.reg in case some things changed
	if [[ -e ${ROOT}/usr/$(get_libdir)/mozilla/regxpcom ]]; then
		export MOZILLA_FIVE_HOME="${ROOT}/usr/$(get_libdir)/mozilla"

		if [[ -x ${MOZILLA_FIVE_HOME}/mozilla-rebuild-databases.pl ]]; then
			${MOZILLA_FIVE_HOME}/mozilla-rebuild-databases.pl
			# Fix directory permissions
			find ${MOZILLA_FIVE_HOME}/ -type d -perm 0700 -exec chmod 755 {} \;
			# Fix permissions on chrome files
			find ${MOZILLA_FIVE_HOME}/chrome/ -name '*.rdf' -exec chmod 0644 {} \;
		fi
	fi

	update_mozilla_launcher_symlinks
}
