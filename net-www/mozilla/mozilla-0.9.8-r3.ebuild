# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Martin Schlemmer <azarah@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-www/mozilla/mozilla-0.9.8-r3.ebuild,v 1.4 2002/04/26 06:16:57 seemant Exp $

S=${WORKDIR}/mozilla
DESCRIPTION="The Mozilla Web Browser"
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla/releases/mozilla${PV}/src/${PN}-source-${PV}.tar.bz2"
HOMEPAGE="http://www.mozilla.org"

RDEPEND=">=gnome-base/ORBit-0.5.10-r1
	=dev-libs/glib-1.2*
	>=media-libs/jpeg-6b
	>=media-libs/libpng-1.0.9
	app-arch/zip
	app-arch/unzip
	x11-libs/gtk+
	java?  ( virtual/jdk )"
#	gtk?   ( x11-libs/gtk+ )
#	mozqt? ( x11-libs/qt )"

DEPEND="${RDEPEND}
	virtual/x11
	sys-devel/perl"


# needed by src_compile() and src_install()
export MOZILLA_OFFICIAL=1
export BUILD_OFFICIAL=1

# make sure the nss module gets build (for NSS support)
[ "`use ssl`" ] && export MOZ_PSM=1

# do we build java support for the NSS stuff ?
# NOTE: this is broken for the moment
#[ "`use java`" ] && export NS_USE_JDK=1

src_compile() {

	chown -R root.root *

	local myconf
	# NOTE: QT and XLIB toolkit seems very unstable, leave disabled until
	#       tested ok -- azarah
#       if [ "`use mozqt`" ] ; then
		# when you enable this again, remember the qt dir is now /usr/qt/2 - danarmak
#               myconf="--enable-toolkit-qt --enable-default-toolkit=qt"
#               myconf="${myconf} --disable-toolkit-gtk --disable-toolkit-xlib"
#	elif [ "`use gtk`" ] ; then
		myconf="--enable-toolkit-gtk --enable-default-toolkit=gtk"
		myconf="${myconf} --disable-toolkit-qt --disable-toolkit-xlib"
#	else
#		myconf="--enable-toolkit-xlib --enable-default-toolkit=xlib"
#		myconf="${myconf} --disable-toolkit-qt --disable-toolkit-gtk"
#	fi

	if [ -z "`use ldap`" ] ; then
		myconf="${myconf} --disable-ldap"
	fi

	if [ -z "$DEBUG" ] ; then
		myconf="${myconf} --enable-strip-libs --disable-debug \
			--disable-dtd-debug --disable-tests"
	fi


	# NB!!:  Due to the fact that the non default extensions do not always
	#        compile properly, using them is considered unsupported, and
	#        is just here for completeness.  Please do not use if you 
	#        do not know what you are doing!
	#
	# The defaults are (as of 0.9.7, according to configure (line ~10251)):
	#     cookie wallet content-packs xml-rpc xmlextras help transformiix venkman inspector
	# Non-defaults are:
	#     irc xmlterm access-builtin ctl
	local myext="default"
	if [ "`use mozirc`" ] ; then
		myext="${myext},irc"
	fi
	if [ "`use mozxmlterm`" ] ; then
		myext="${myext},xmlterm"
	fi
	if [ "`use mozaccess-builtin`" ] ; then
		myext="${myext},access-builtin"
	fi
	if [ "`use mozctl`" ] ; then
		myext="${myext},ctl"
	fi
	
	
	export BUILD_MODULES=all
	export BUILD_OPT=1

	# Crashes on start when compiled with -fomit-frame-pointer
	CFLAGS="${CFLAGS/-fomit-frame-pointer}"
	CXXFLAGS="${CXXFLAGS/-fomit-frame-pointer}"

	./configure  --prefix=/usr/lib/mozilla 				\
		     --disable-tests		 			\
		     --disable-pedantic					\
		     --enable-mathml					\
		     --disable-svg					\
		     --enable-xsl					\
		     --enable-crypto					\
		     --enable-detect-webshell-leaks			\
		     --enable-xinerama					\
		     --with-java-supplement				\
		     --enable-nspr-autoconf				\
		     --with-extensions="${myext}"			\
		     --enable-optimize=-O3				\
		     --enable-xterm-updates				\
		     --with-default-mozilla-five-home=/usr/lib/mozilla	\
		     ${myconf} || die

#	make depend || die
	make || die

	# Build the NSS/SSL support
	if [ "`use ssl`" ] ; then
		cd ${S}/security/coreconf
		
		# Fix #include problem
		cp headers.mk headers.mk.orig
		echo 'INCLUDES += -I$(DIST)/include/nspr -I$(DIST)/include/dbm'\
			>>headers.mk

		make || die

		cd ${S}/security/nss
		
		make moz_import || die
		make || die
		cd ${S}
	fi
}

src_install() {

	# Copy the include and idl files
	dodir /usr/lib/mozilla/include/idl /usr/include
	cd ${S}/dist
	cp -LfR include/* ${D}/usr/lib/mozilla/include
	cp -LfR idl/* ${D}/usr/lib/mozilla/include/idl
	dosym /usr/lib/mozilla/include /usr/include/mozilla

	# Build the Release Tarball
	cd ${S}/xpinstall/packager
	make || die
	dodir /usr/lib

	tar xzf ${S}/dist/mozilla-`uname -m`-pc-linux-gnu.tar.gz 	\
		-C ${D}/usr/lib

	# Install the development tools in /usr
	dodir /usr/bin
	mv ${D}/usr/lib/mozilla/{xpcshell,xpidl,xpt_dump,xpt_link} ${D}/usr/bin

	# Install the NSS/SSL libs, headers and tools
	if [ "`use ssl`" ] ; then
		# Install the headers ('make install' do not work for headers ...)
		insinto /usr/lib/mozilla/include/nss
		doins ${S}/dist/public/seccmd/*.h
		doins ${S}/dist/public/security/*.h

		cd ${S}/security/nss

		mkdir -p ${WORKDIR}/nss/{bin,lib}
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

	cd ${S}
	exeinto /usr/bin
	doexe ${FILESDIR}/mozilla
	insinto /etc/env.d
	doins ${FILESDIR}/10mozilla
	dodoc LEGAL LICENSE README/mozilla/README*

	# Fix icons to look the same everywhere
	insinto /usr/lib/mozilla/icons
	doins ${S}/build/package/rpm/SOURCES/mozicon16.xpm
	doins ${S}/build/package/rpm/SOURCES/mozicon50.xpm

        # Install icon and .desktop for menu entry
	if [ "`use gnome`" ] ; then
		insinto /usr/share/pixmaps
		doins ${S}/build/package/rpm/SOURCES/mozilla-icon.png

		# Fix comment of menu entry
		cd ${S}/build/package/rpm/SOURCES
		cp mozilla.desktop mozilla.desktop.orig
		sed -e 's:Comment=Mozilla:Comment=Mozilla Web Browser:'	\
			mozilla.desktop.orig >mozilla.desktop
		cd ${S}
		insinto /usr/share/gnome/apps/Internet
		doins ${S}/build/package/rpm/SOURCES/mozilla.desktop
        fi

	# Take care of non root execution
	# (seems the problem is that not all files are readible by the user)
	chmod -R g+r,o+r ${D}/usr/lib/mozilla
}

pkg_preinst() {
	# Stale components and chrome files break when unmerging old
	if [ -d ${ROOT}/usr/lib/mozilla/components ]
	then
		rm -rf ${ROOT}/usr/lib/mozilla/components
	fi
	if [ -d ${ROOT}/usr/lib/mozilla/components ]
	then 
		rm -rf ${ROOT}/usr/lib/mozilla/chrome
	fi
}

pkg_postinst() {

        # Make symlink for Java plugin (do not do in src_install(), else it only
	# gets installed every second time)
	if [ "`use java`" ] && [ ! -L /usr/lib/mozilla/plugins/`java-config --browser-plugin=mozilla` ]
	then
		if [ -e `java-config --full-browser-plugin-path=mozilla` ]
		then
			ln -sf `java-config --full-browser-plugin-path=mozilla` \
				/usr/lib/mozilla/plugins/`java-config --browser-plugin=mozilla` 
		fi
	fi

	# Take care of component registration
	export MOZILLA_FIVE_HOME="${ROOT}/usr/lib/mozilla"

	# Remove any stale component.reg
	if [ -e ${ROOT}/usr/lib/mozilla/component.reg ] ; then
		rm -f ${ROOT}/usr/lib/mozilla/component.reg
	fi

	# Tempory fix for missing libtimer_gtk.so
	# If it exists when generating component.reg (before unmerge of old),
	# it 'corrupts' the newly generated component.reg with invalid references.
	if [ -e ${ROOT}/usr/lib/mozilla/components/libtimer_gtk.so ] ; then
		rm -f ${ROOT}/usr/lib/mozilla/components/libtimer_gtk.so
	fi

	# Needed to update the run time bindings for REGXPCOM 
	# (do not remove next line!)
	env-update
	# Register components, setup Chrome .rdf files and fix file permissions
	umask 022
	${ROOT}/usr/lib/mozilla/regxpcom
	chmod g+r,o+r ${ROOT}/usr/lib/mozilla/component.reg
	# Setup the default skin and locale to correctly generate the Chrome .rdf files
	echo "skin,install,select,classic/1.0" >> ${MOZILLA_FIVE_HOME}/chrome/installed-chrome.txt
	echo "locale,install,select,en-US" >> ${MOZILLA_FIVE_HOME}/chrome/installed-chrome.txt
	${ROOT}/usr/lib/mozilla/regchrome
	find ${ROOT}/usr/lib/mozilla -type d -perm 0700 -exec chmod 755 {} \; || :

    
	echo
	echo "*****************************************************************"
	echo "* NB:  Please unmerge old versions prior to 0.9.5 as the header *"
	echo "* layout in /usr/lib/mozilla/include have changed and will      *"
	echo "* result in compile errors when compiling programs that need    *"
	echo "* mozilla headers and libs (galeon, nautilus, ...)              *"
	echo "*****************************************************************"
	echo
}

pkg_postrm() {

	# Regenerate component.reg in case some things changed
	if [ -e ${ROOT}/usr/lib/mozilla/regxpcom ] ; then
	
		if [ -e ${ROOT}/usr/lib/mozilla/component.reg ] ; then
			rm -f ${ROOT}/usr/lib/mozilla/component.reg
		fi
		
		${ROOT}/usr/lib/mozilla/regxpcom
		chmod g+r,o+r ${ROOT}/usr/lib/mozilla/component.reg
	fi
}

