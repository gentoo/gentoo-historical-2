# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/mozilla/mozilla-1.2.ebuild,v 1.6 2002/12/04 19:19:51 azarah Exp $

IUSE="java crypt ipv6 gtk2 ssl ldap gnome"
# Internal USE flags that I do not really want to advertise ...
IUSE="${IUSE} mozsvg mozcalendar mozaccess mozinterfaceinfo mozp3p mozxmlterm moznoirc moznomail moznocompose"

inherit flag-o-matic gcc makeedit eutils nsplugins

# Crashes on start when compiled with -fomit-frame-pointer
filter-flags "-fomit-frame-pointer"

# Recently there has been a lot of stability problem in Gentoo-land.  Many
# things can be the cause to this, but I believe that it is due to gcc3
# still having issues with optimizations, or with it not filtering bad
# combinations (protecting the user maybe from himeself) yet.
#
# This can clearly be seen in large builds like glibc, where too aggressive
# CFLAGS cause the tests to fail miserbly.
#
# Quote from Nick Jones <carpaski@gentoo.org>, who in my opinion
# knows what he is talking about:
#
#   People really shouldn't force code-specific options on... It's a
#   bad idea. The -march options aren't just to look pretty. They enable
#   options that are sensible (and include sse,mmx,3dnow when apropriate).
#
# The next command strips CFLAGS and CXXFLAGS from nearly all flags.  If
# you do not like it, comment it, but do not bugreport if you run into
# problems.
#
# <azarah@gentoo.org> (13 Oct 2002)
strip-flags

EMVER="0.71.0"
IPCVER="1.0.1"

FCVER="2.0"

PATCH_VER="1.0"

# handle _rc versions
MY_PV1="${PV/_}"
MY_PV2="${MY_PV1/eta}"
S="${WORKDIR}/mozilla"
FC_S="${WORKDIR}/fcpackage.${FCVER/\./_}/Xft"
DESCRIPTION="The Mozilla Web Browser"
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla/releases/${PN}${MY_PV2}/src/${PN}-source-${MY_PV2}.tar.bz2
	crypt? ( http://enigmail.mozdev.org/dload/src/enigmail-${EMVER}.tar.gz
	         http://enigmail.mozdev.org/dload/src/ipc-${IPCVER}.tar.gz )
	http://fontconfig.org/release/fcpackage.${FCVER/\./_}.tar.gz"
#	mirror://gentoo/distfiles/${P}-patches-${PATCH_VER}.tar.bz2"
HOMEPAGE="http://www.mozilla.org"

KEYWORDS="~x86 ~ppc ~sparc ~sparc64 ~alpha"
SLOT="0"
LICENSE="MPL-1.1 NPL-1.1"

RDEPEND=">=x11-base/xfree-4.2.0-r11
	>=gnome-base/ORBit-0.5.10-r1
	>=dev-libs/libIDL-0.8.0
	>=sys-libs/zlib-1.1.4
	>=media-libs/jpeg-6b
	>=media-libs/libpng-1.2.1
	>=sys-apps/portage-2.0.14
	dev-libs/expat
	app-arch/zip
	app-arch/unzip
	( gtk2? >=x11-libs/gtk+-2.0.9 :
	        =x11-libs/gtk+-1.2* )
	( gtk2? >=dev-libs/glib-2.0.6 :
	        =dev-libs/glib-1.2* )
	!gtk2? ( >=media-libs/fontconfig-2.0-r3 )
	java?  ( virtual/jre )
	crypt? ( >=app-crypt/gnupg-1.2.1 )"

DEPEND="${RDEPEND}
	virtual/x11
	dev-util/pkgconfig
	sys-devel/perl
	java? ( >=dev-java/java-config-0.2.0 )"


pkg_setup() {

	# Setup CC and CXX
	if [ -z "${CC}" ]
	then
		export CC="gcc"

		if [ "$(gcc-major-version)" -eq "3" ]
		then
			export CXX="g++"
		else
			export CXX="gcc"
		fi
	fi
	if [ -z "${CXX}" ]
	then
		export CXX="${CC}"
	fi

	#This should enable parallel builds, I hope
	if [ -f /proc/cpuinfo ]
	then
		# Set MAKEOPTS to have proper -j? option ..
		get_number_of_jobs
		export MAKE="emake"
	fi

	# needed by src_compile() and src_install()
	export MOZILLA_OFFICIAL=1
	export BUILD_OFFICIAL=1

	# enable XFT
	if [ "${DISABLE_XFT}" != "1" ]
	then
		export MOZ_ENABLE_XFT="1"
	fi
	
	# make sure the nss module gets build (for NSS support)
	if [ -n "`use ssl`" ]
	then
		export MOZ_PSM="1"
	fi

	# do we build java support for the NSS stuff ?
	# NOTE: this is broken for the moment
#	if [ "`use java`" ]
#	then
#		export NS_USE_JDK="1"
#	fi
}

src_unpack() {
	
	unpack ${A}

	# The release branch do not contain all the fixes that are in
	# the main branch
	#
	#   http://bugzilla.mozilla.org/show_bug.cgi?id=182506
# Included in updated tarball ...
#	epatch ${FILESDIR}/${PV}/${P}-branch-update.patch.bz2

	if [ "$(gcc-major-version)" -eq "3" ]
	then
		# ABI Patch for alpha/xpcom for gcc-3.x
		if [ "${ARCH}" = "alpha" ]
		then
			cd ${S}; epatch ${FILESDIR}/${PN}-alpha-xpcom-subs-fix.patch
		fi
	fi

	# A patch for mozilla to disregard the PLATFORM variable, which
	# can break compiles (has done for sparc64).  See:
	# http://bugzilla.mozilla.org/show_bug.cgi?id=174143
	cd ${S}; epatch ${FILESDIR}/${PN}-1.0.1-platform.patch

	epatch ${FILESDIR}/${PV}/${P}b-default-plugin-less-annoying.patch.bz2
	epatch ${FILESDIR}/${PV}/${P}b-over-the-spot.patch.bz2
	epatch ${FILESDIR}/${PV}/${P}b-freetype.patch.bz2
	epatch ${FILESDIR}/${PV}/${P}b-wallet.patch.bz2

	# Pasting from another app to mozilla do not always work if data
	# to be pasted is larger than 4k:
	#
	#   http://bugzilla.mozilla.org/show_bug.cgi?id=56219
	#
	# <azarah@gentoo.org> (30 Nov 2002)
	epatch ${FILESDIR}/${PV}/${P}-cutnpaste-limit-fix.patch.bz2

	if [ -z "`use gtk2`" ]
	then
		# Get mozilla to link to Xft2.0 that we install in tmp directory
		# <azarah@gentoo.org> (18 Nov 2002)
		epatch ${FILESDIR}/${PV}/${P}b-Xft-includes.patch.bz2
	else
		# Update Gtk+2 bits from CVS
		epatch ${FILESDIR}/${PV}/${P}b-gtk2.patch.bz2
	fi
	
	cd ${S}
	export WANT_AUTOCONF_2_1=1
	autoconf &> /dev/null
	unset WANT_AUTOCONF_2_1

	# Unpack the enigmail plugin
	if [ -n "`use crypt`" -a -z "`use moznomail`" ]
	then
		mv -f ${WORKDIR}/ipc ${S}/extensions/
		mv -f ${WORKDIR}/enigmail ${S}/extensions/
	fi

	cd ${FC_S}
	export WANT_AUTOCONF_2_5=1
	autoconf --force &> /dev/null
	unset WANT_AUTOCONF_2_5
}

src_compile() {

	local myconf=""
	# NOTE: QT and XLIB toolkit seems very unstable, leave disabled until
	#       tested ok -- azarah
	if [ -n "`use gtk2`" ]
	then
		myconf="${myconf} --enable-toolkit-gtk2 \
		                  --enable-default-toolkit=gtk2 \
		                  --disable-toolkit-qt \
		                  --disable-toolkit-xlib \
		                  --disable-toolkit-gtk"
	else
		myconf="${myconf} --enable-toolkit-gtk \
			              --enable-default-toolkit=gtk \
			              --disable-toolkit-qt \
			              --disable-toolkit-xlib \
			              --disable-toolkit-gtk2"
	fi

	if [ -z "`use ldap`" ]
	then
		myconf="${myconf} --disable-ldap"
	fi

	if [ "${DEBUGBUILD}" != "yes" ]
	then
		myconf="${myconf} --enable-strip-libs \
			              --disable-debug \
			              --disable-tests \
						  --disable-dtd-debug \
						  --disable-jsd \
						  --enable-reorder \
						  --enable-strip \
						  --enable-elf-dynstr-gc \
						  --enable-cpp-rtti"

		if [ -z "`use gtk2`" ]
		then
			myconf="${myconf} --disable-accessibility \
							  --disable-logging"
		fi
	fi

	if [ -n "${MOZ_ENABLE_XFT}" ]
	then
		if [ -n "`use gtk2`" ]
		then
			local pango_version=""
			
		    pango_version="`pkg-config --modversion pango | cut -d. -f1,2`"
			pango_version="`echo ${pango_version} | sed -e 's:\.::g'`"
		
			# Only enable Xft if we have pango-1.1 *and* Xft2.0; or
			# just Xft2.0 installed ...
			if ([ "${pango_version}" -gt "10" ] && (pkg-config xft 2> /dev/null)) \
			   || (pkg-config xft 2> /dev/null)
			then
				einfo "Building with Xft2.0 support!"
				myconf="${myconf} --enable-xft"
			else
				myconf="${myconf} --disable-xft"
			fi
		else
			einfo "Building with Xft2.0 support!"
			myconf="${myconf} --enable-xft"
		fi
	fi

	if [ -n "`use ipv6`" ]
	then
		myconf="${myconf} --enable-ipv6"
	fi


	# NB!!:  Due to the fact that the non default extensions do not always
	#        compile properly, using them is considered unsupported, and
	#        is just here for completeness.  Please do not use if you 
	#        do not know what you are doing!
	#
	# The defaults are (as of 1.2, according to configure (line ~11445)):
	#     cookie, wallet, content-packs, xml-rpc, xmlextras, help, pref, transformiix,
	#     venkman, inspector, irc, universalchardet, typeaheadfind
	# Non-defaults are:
	#     xmlterm access-builtin p3p interfaceinfo datetime finger cview
	local myext="default"
	if [ -n "`use mozxmlterm`" ]
	then
		myext="${myext},xmlterm"
	fi
	if [ -n "`use mozaccess-builtin`" ]
	then
		myext="${myext},access-builtin"
	fi
	if [ -n "`use mozp3p`" ]
	then
		myext="${myext},p3p"
	fi
	if [ -n "`use mozinterfaceinfo`" ]
	then
		myext="${myext},interfaceinfo"
	fi
	if [ -n "`use moznoirc`" ]
	then
		myext="${myext},-irc"
	fi

	if [ -n "`use mozsvg`" ]
	then
		export MOZ_INTERNAL_LIBART_LGPL="1"
		myconf="${myconf} --enable-svg"
	else
		myconf="${myconf} --disable-svg"
	fi
# This puppy needs libical, which is not in portage yet.  Also make mozilla
# depend on swig, so not sure if its the best idea around to enable ...
#	if [ -n "`use mozcalendar`" ]
#	then
#		myconf="${myconf} --enable-calendar"
#	fi
	
	if [ -n "`use moznomail`" ]
	then
		myconf="${myconf} --disable-mailnews"
	fi
	if [ -n "`use moznocompose`" ]
	then
		myconf="${myconf} --disable-composer"
	fi
	
	if [ "$(gcc-major-version)" -eq "3" ]
	then
		# If CXX is not set, 'c++' is used to compile and not 'g++', which
		# could cause problems.
		if [ -z "${CC}" -o -z "${CXX}" ]
		then
			eerror "CC or CXX are not set.  This may be due to pkg_setup() not"
			eerror "being run.  Please file a bug report that include your portage"
			eerror "version, USE flags and CFLAGS."
			die "CC or CXX are not set!"
		fi
		
		# Currently gcc-3.2 or older do not work well if we specify "-march"
		# and other optimizations for pentium4.
		if [ "$(${CC} -dumpversion | sed -e 's:\.::g')" -lt "321" ]
		then
			export CFLAGS="${CFLAGS/pentium4/pentium3}"
			export CXXFLAGS="${CXXFLAGS/pentium4/pentium3}"
		fi

		# Enable us to use flash, etc plugins compiled with gcc-2.95.3
		if [ "${ARCH}" = "x86" ]
		then
			myconf="${myconf} --enable-old-abi-compat-wrappers"
		fi
	fi

	# *********************************************************************
	#
	#  Configure and build Xft2.0 and Xrender
	#
	# *********************************************************************

	if [ -z "`use gtk2`" ]
	then
		cd ${FC_S}
		einfo "Configuring Xft2.0..."
		mkdir -p ${WORKDIR}/Xft
		./configure --prefix=${WORKDIR}/Xft || die
	
		einfo "Building Xft2.0..."
		emake || die
	
		einfo "Installing Xft2.0 in temp directory..."
		make prefix=${WORKDIR}/Xft \
			confdir=${WORKDIR}/Xft/etc/fonts \
			datadir=${WORKDIR}/Xft/share \
			install || die

		# We also need to update Xrender ..
		cd ${FC_S}/../Xrender
		einfo "Compiling Xrender..."
		xmkmf
		make
		cp -df Xrender.h extutil.h region.h render.h renderproto.h \
			${WORKDIR}/Xft/include
		cp -df libXrender.so* ${WORKDIR}/Xft/lib

		# Where is Xft2.0 located ?
		export PKG_CONFIG_PATH="${WORKDIR}/Xft/lib/pkgconfig"
	fi

	# *********************************************************************
	#
	#  Configure and build Mozilla
	#
	# *********************************************************************
	
	export BUILD_MODULES=all
	export BUILD_OPT=1
	
	# Get it to work without warnings on gcc3
	export CXXFLAGS="${CXXFLAGS} -Wno-deprecated"

	cd ${S}
	einfo "Configuring Mozilla..."
	./configure --prefix=/usr/lib/mozilla \
		--disable-pedantic \
		--disable-short-wchar \
		--without-mng \
		--disable-xprint \
		--enable-mathml \
		--without-system-nspr \
		--enable-nspr-autoconf \
		--with-system-zlib \
		--enable-xsl \
		--enable-crypto \
		--with-java-supplement \
		--with-pthreads \
		--enable-extensions="${myext}" \
		--enable-optimize="-O2" \
		--with-default-mozilla-five-home=/usr/lib/mozilla \
		${myconf} || die

	edit_makefiles
	einfo "Building Mozilla..."
	make WORKDIR="${WORKDIR}" || die

	# *********************************************************************
	#
	#  Build Mozilla NSS
	#
	# *********************************************************************

	# Build the NSS/SSL support
	if [ "`use ssl`" ]
	then
		einfo "Building Mozilla NSS..."
		cd ${S}/security/coreconf
		
		# Fix #include problem
		cp headers.mk headers.mk.orig
		echo 'INCLUDES += -I$(DIST)/include/nspr -I$(DIST)/include/dbm'\
			>>headers.mk

		# Disable jobserver here ...
		make MAKE="make" || die

		cd ${S}/security/nss
		
		# Disable jobserver here ...
		make MAKE="make" moz_import || die
		make MAKE="make" || die
		cd ${S}
	fi

	# *********************************************************************
	#
	#  Build Enigmail plugin
	#
	# *********************************************************************

	# Build the enigmail plugin
	if [ -n "`use crypt`" -a -z "`use moznomail`" ]
	then
		einfo "Building Enigmail plugin..."
		cd ${S}/extensions/ipc
		make || die

		cd ${S}/extensions/enigmail
		make || die
	fi
}

src_install() {

	# Install, don't create tarball
	dodir /usr/lib
	cd ${S}/xpinstall/packager
	einfo "Installing mozilla into build root..."
	make MOZ_PKG_FORMAT="raw" TAR_CREATE_FLAGS="-chf" > /dev/null || die
	mv -f ${S}/dist/mozilla ${D}/usr/lib/mozilla

	if [ -z "`use gtk2`" ]
	then
		einfo "Installing Xft2.0..."
		cp -df ${WORKDIR}/Xft/lib/libXft.so.* ${D}/usr/lib/mozilla
		cp -df ${WORKDIR}/Xft/lib/libXrender.so.* ${D}/usr/lib/mozilla
	fi

	einfo "Installing includes and idl files..."
	# Copy the include and idl files
	dodir /usr/lib/mozilla/include/idl /usr/include
	cd ${S}/dist
	cp -LfR include/* ${D}/usr/lib/mozilla/include
	cp -LfR idl/* ${D}/usr/lib/mozilla/include/idl
	dosym /usr/lib/mozilla/include /usr/include/mozilla

	# Install the development tools in /usr
	dodir /usr/bin
	mv ${D}/usr/lib/mozilla/{xpcshell,xpidl,xpt_dump,xpt_link} ${D}/usr/bin

	# Install the NSS/SSL libs, headers and tools
	if [ "`use ssl`" ]
	then
		einfo "Installing Mozilla NSS..."
		# Install the headers ('make install' do not work for headers ...)
		insinto /usr/lib/mozilla/include/nss
		doins ${S}/dist/public/seccmd/*.h
		doins ${S}/dist/public/security/*.h

		cd ${S}/security/nss

		mkdir -p ${WORKDIR}/nss/{bin,lib}
		export BUILD_OPT=1
		export SOURCE_BIN_DIR=${WORKDIR}/nss/bin
		export SOURCE_LIB_DIR=${WORKDIR}/nss/lib

		make install || die
		# Gets installed as symbolic links ...
		cp -Lf ${WORKDIR}/nss/bin/* ${D}/usr/bin
		cp -Lf ${WORKDIR}/nss/lib/* ${D}/usr/lib/mozilla

		# Need to unset these incase we want to rebuild, else the build
		# gets newked.
		unset SOURCE_LIB_DIR
		unset SOURCE_BIN_DIR
	fi

	cd ${S}/build/unix
	# Fix mozilla-config and install it
	perl -pi -e "s:/lib/mozilla-${MY_PV2}::g" mozilla-config
	perl -pi -e "s:/mozilla-${MY_PV2}::g" mozilla-config
	exeinto /usr/lib/mozilla
	doexe mozilla-config
	# Fix pkgconfig files and install them
	insinto /usr/lib/pkgconfig
	for x in *.pc
	do
		if [ -f ${x} ]
		then
			perl -pi -e "s:/lib/mozilla-${MY_PV2}::g" ${x}
			perl -pi -e "s:/mozilla-${MY_PV2}::g" ${x}
			doins ${x}
		fi
	done

	cd ${S}
	exeinto /usr/bin
	newexe ${FILESDIR}/mozilla.sh mozilla
	insinto /etc/env.d
	doins ${FILESDIR}/10mozilla
	dodoc LEGAL LICENSE README/mozilla/README*

	# Move plugins dir
	src_mv_plugins usr/lib/mozilla/plugins

	# Fix icons to look the same everywhere
	insinto /usr/lib/mozilla/icons
	doins ${S}/build/package/rpm/SOURCES/mozicon16.xpm
	doins ${S}/build/package/rpm/SOURCES/mozicon50.xpm

	# Install icon and .desktop for menu entry
	if [ "`use gnome`" ]
	then
		insinto /usr/share/pixmaps
		doins ${S}/build/package/rpm/SOURCES/mozilla-icon.png

		# Fix comment of menu entry
		cd ${S}/build/package/rpm/SOURCES
		perl -pi -e 's:Comment=Mozilla:Comment=Mozilla Web Browser:' mozilla.desktop
		cd ${S}
		insinto /usr/share/gnome/apps/Internet
		doins ${S}/build/package/rpm/SOURCES/mozilla.desktop
	fi

	# Take care of non root execution
	# (seems the problem is that not all files are readible by the user)
	einfo "Fixing Permissions..."
	chmod -R g+r,o+r ${D}/usr/lib/mozilla
	find ${D}/usr/lib/mozilla/ -type d -exec chmod 0755 {} \; || :
}

pkg_preinst() {
	# Stale components and chrome files break when unmerging old
	if [ -d ${ROOT}/usr/lib/mozilla/components ]
	then
		rm -rf ${ROOT}/usr/lib/mozilla/components
	fi
	if [ -d ${ROOT}/usr/lib/mozilla/chrome ]
	then
		rm -rf ${ROOT}/usr/lib/mozilla/chrome
	fi

	# Remove stale component registry.
    if [ -e ${ROOT}/usr/lib/component.reg ]
	then
		rm -f ${ROOT}/usr/lib/component.reg
	fi

	# Move old plugins dir
	pkg_mv_plugins /usr/lib/mozilla/plugins
}

pkg_postinst() {

	export MOZILLA_FIVE_HOME="${ROOT}/usr/lib/mozilla"

	# Make symlink for Java plugin (do not do in src_install(), else it only
	# gets installed every second time)
	if [ "`use java`" -a "`gcc-major-version`" -ne "3" \
	     -a ! -L ${MOZILLA_FIVE_HOME}/plugins/`java-config --browser-plugin=mozilla` ]
	then
		if [ -e `java-config --full-browser-plugin-path=mozilla` ]
		then
			ln -snf `java-config --full-browser-plugin-path=mozilla` \
				${MOZILLA_FIVE_HOME}/plugins/`java-config --browser-plugin=mozilla` 
		fi
	fi

	# Take care of component registration

	# Remove any stale component.reg
	if [ -e ${MOZILLA_FIVE_HOME}/component.reg ]
	then
		rm -f ${MOZILLA_FIVE_HOME}/component.reg
	fi

	umask 022

	# Needed to update the run time bindings for REGXPCOM 
	# (do not remove next line!)
	env-update
	# Register components, setup Chrome .rdf files and fix file permissions
	einfo "Registering Components and Chrome..."
	${MOZILLA_FIVE_HOME}/regxpcom &> /dev/null
	if [ -e ${MOZILLA_FIVE_HOME}/component.reg ]
	then
		chmod 0644 ${MOZILLA_FIVE_HOME}/component.reg
	fi
	# Setup the default skin and locale to correctly generate the Chrome .rdf files
	rm -rf ${MOZILLA_FIVE_HOME}/chrome/overlayinfo
	find ${MOZILLA_FIVE_HOME}/chrome/ -name '*.rdf' -exec rm -f {} \; || :
	echo "skin,install,select,classic/1.0" >> \
		${MOZILLA_FIVE_HOME}/chrome/installed-chrome.txt
	echo "locale,install,select,en-US" >> \
		${MOZILLA_FIVE_HOME}/chrome/installed-chrome.txt
	${MOZILLA_FIVE_HOME}/regchrome &> /dev/null
	find ${MOZILLA_FIVE_HOME}/chrome/ -name '*.rdf' -exec chmod 0644 {} \; || :


	echo
	ewarn "Please unmerge old versions of mozilla, as the header"
	ewarn "layout in /usr/lib/mozilla/include have changed and will"
	ewarn "result in compile errors when compiling programs that need"
	ewarn "mozilla headers and libs (galeon, nautilus, ...)"
}

pkg_postrm() {

	# Regenerate component.reg in case some things changed
	if [ -e ${ROOT}/usr/lib/mozilla/regxpcom ]
	then
		export MOZILLA_FIVE_HOME="${ROOT}/usr/lib/mozilla"
	
		if [ -e ${MOZILLA_FIVE_HOME}/component.reg ]
		then
			rm -f ${MOZILLA_FIVE_HOME}/component.reg
		fi

		${MOZILLA_FIVE_HOME}/regxpcom
		if [ -e ${MOZILLA_FIVE_HOME}/component.reg ]
		then
			chmod g+r,o+r ${MOZILLA_FIVE_HOME}/component.reg
		fi

		rm -rf ${MOZILLA_FIVE_HOME}/chrome/overlayinfo
		find ${MOZILLA_FIVE_HOME}/chrome/ -name '*.rdf' -exec rm -f {} \; || :
		${MOZILLA_FIVE_HOME}/regchrome
		find ${MOZILLA_FIVE_HOME}/ -type d -perm 0700 -exec chmod 755 {} \; || :
	fi
}

