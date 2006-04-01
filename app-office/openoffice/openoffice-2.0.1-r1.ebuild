# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/openoffice/openoffice-2.0.1-r1.ebuild,v 1.2 2006/04/01 12:14:53 blubb Exp $

inherit eutils fdo-mime flag-o-matic kde-functions toolchain-funcs

IUSE="binfilter eds gnome gtk java kde ldap mozilla xml2"

MY_PV="${PV}.3"
PATCHLEVEL="OOA680"
SRC="OOO_2_0_1"
S="${WORKDIR}/ooo-build-${MY_PV}"
CONFFILE="${S}/distro-configs/Gentoo.conf.in"
DESCRIPTION="OpenOffice.org, a full office productivity suite."

SRC_URI="http://go-oo.org/packages/${PATCHLEVEL}/${SRC}-core.tar.bz2
	http://go-oo.org/packages/${PATCHLEVEL}/${SRC}-system.tar.bz2
	http://go-oo.org/packages/${PATCHLEVEL}/${SRC}-lang.tar.bz2
	binfilter? ( http://go-oo.org/packages/${PATCHLEVEL}/${SRC}-binfilter.tar.bz2 )
	http://go-oo.org/packages/${PATCHLEVEL}/ooo-build-${MY_PV}.tar.gz
	http://go-ooo.org/packages/libwpd/libwpd-0.8.3.tar.gz
	http://go-oo.org/packages/SRC680/ooo_crystal_images-6.tar.bz2
	http://go-oo.org/packages/SRC680/extras-2.tar.bz2"

HOMEPAGE="http://go-oo.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="-amd64 ppc sparc x86"

RDEPEND="!app-office/openoffice-bin
	|| ( (
			x11-libs/libXaw
			x11-libs/libXinerama
		)
		virtual/x11 )
	virtual/libc
	>=dev-lang/perl-5.0
	gnome? ( >=x11-libs/gtk+-2.4
		>=gnome-base/gnome-vfs-2.6
		>=gnome-base/gconf-2.0 )
	gtk? ( >=x11-libs/gtk+-2.4 )
	eds? ( >=gnome-extra/evolution-data-server-1.2 )
	kde? ( kde-base/kdelibs )
	mozilla? ( >=www-client/mozilla-1.7.10 )
	>=x11-libs/startup-notification-0.5
	>=media-libs/freetype-2.1.4
	>=media-libs/fontconfig-2.2.0
	media-libs/libpng
	sys-devel/flex
	sys-devel/bison
	app-arch/zip
	app-arch/unzip
	dev-libs/expat
	java? ( >=virtual/jre-1.4 )
	>=sys-devel/gcc-3.2.1
	linguas_ja? ( >=media-fonts/kochi-substitute-20030809-r3 )
	linguas_zh_CN? ( >=media-fonts/arphicfonts-0.1-r2 )
	linguas_zh_TW? ( >=media-fonts/arphicfonts-0.1-r2 )"

DEPEND="${RDEPEND}
	|| ( (
			x11-libs/libXrender
			x11-proto/printproto
			x11-proto/xextproto
			x11-proto/xproto
			x11-proto/xineramaproto
		)
		virtual/x11 )
	net-print/cups
	>=sys-apps/findutils-4.1.20-r1
	app-shells/tcsh
	dev-perl/Archive-Zip
	dev-util/pkgconfig
	dev-util/intltool
	>=net-misc/curl-7.9.8
	sys-libs/zlib
	sys-libs/pam
	!dev-util/dmake
	>=dev-lang/python-2.3.4
	java? ( >=virtual/jdk-1.4
		dev-java/ant-core
		>=dev-java/java-config-1.2.11-r1 )
	!java? ( dev-libs/libxslt
		>=dev-libs/libxml2-2.0 )
	ldap? ( net-nds/openldap )
	xml2? ( >=dev-libs/libxml2-2.0 )"

PROVIDE="virtual/ooo"

pkg_setup() {

	ewarn
	ewarn " It is important to note that OpenOffice.org is a very fragile  "
	ewarn " build when it comes to CFLAGS.  A number of flags have already "
	ewarn " been filtered out.  If you experience difficulty merging this  "
	ewarn " package and use agressive CFLAGS, lower the CFLAGS and try to  "
	ewarn " merge again. Also note that building OOo takes a lot of time and "
	ewarn " hardware ressources: 4-6 GB free diskspace and 256 MB RAM are "
	ewarn " the minimum requirements. If you have less, use openoffice-bin "
	ewarn " instead. "
	ewarn

	strip-linguas af ar be_BY bg bn br bs ca cs cy da de el en en_GB en_US en_ZA es et fa fi fr ga gu_IN he hi_IN hr hu it ja km ko lo lt lv mk nb ne nl nn nr ns pa_IN pl pt_BR ru rw sh_YU sk sl sr_CS st sv sw_TZ th tn tr vi xh zh_CN zh_TW zu

	if [ -z "${LINGUAS}" ]; then
		export LINGUAS_OOO="en-US"
		ewarn " To get a localized build, set the according LINGUAS variable(s). "
		ewarn
	else
		export LINGUAS_OOO="${LINGUAS//en/en_US}"
		export LINGUAS_OOO="${LINGUAS_OOO//en_US_GB/en_GB}"
		export LINGUAS_OOO="${LINGUAS_OOO//en_US_US/en_US}"
		export LINGUAS_OOO="${LINGUAS_OOO//_/-}"
	fi

	if use !java; then
		ewarn " You are building with java-support disabled, this results in some "
		ewarn " of the OpenOffice.org functionality (i.e. help) being disabled. "
		ewarn " If something you need does not work for you, rebuild with "
		ewarn " java in your USE-flags. Also the xml2 use-flag is disabled with "
		ewarn " -java to prevent build breakage. "
		ewarn
	elif use sparc; then
		ewarn " Java support on sparc is very flaky, we don't recommend "
		ewarn " building openoffice this way."
		ebeep 5
		epause 10
	fi

	#Detect which look and patchset we are using, amd64 is known not to be working atm, so this is here for testing purposes only
	use amd64 && export DISTRO="Gentoo64" || export DISTRO="Gentoo"

}

src_unpack() {

	unpack ooo-build-${MY_PV}.tar.gz

	#Some fixes for our patchset
	cd ${S}
	epatch ${FILESDIR}/${PV}/alwayscrystal.diff

	#Use flag checks
	use java && echo "--with-jdk-home=${JAVA_HOME} --with-ant-home=${ANT_HOME}" >> ${CONFFILE} || echo "--without-java" >> ${CONFFILE}

	echo "`use_enable binfilter`" >> ${CONFFILE}
	echo "`use_with xml2 system-libxml`" >> ${CONFFILE}

	echo "`use_with mozilla system-mozilla`" >> ${CONFFILE}
	echo "`use_enable mozilla`" >> ${CONFFILE}

	echo "`use_enable ldap openldap`" >> ${CONFFILE}
	echo "`use_enable eds evolution2`" >> ${CONFFILE}
	echo "`use_enable gnome gnome-vfs`" >> ${CONFFILE}
	echo "`use_enable gnome lockdown`" >> ${CONFFILE}

	echo "--with-system-curl"  >> ${CONFFILE}

}

src_compile() {

	unset LIBC
	addpredict "/bin"
	addpredict "/root/.gconfd"
	addpredict "/root/.gnome"

	# Should the build use multiprocessing? Not enabled by default, as it tends to break
	export JOBS="1"
	if [ "${WANT_DISTCC}" == "true" ]; then
		export JOBS=`echo "${MAKEOPTS}" | sed -e "s/.*-j\([0-9]\+\).*/\1/"`
	fi

	# Make sure gnome-users get gtk-support
	export GTKFLAG="`use_enable gtk`" && use gnome && GTKFLAG="--enable-gtk"

	cd ${S}
	autoconf || die
	./configure ${MYCONF} \
		--with-distro="${DISTRO}" \
		--with-vendor="Gentoo" \
		--with-arch="${ARCH}" \
		--with-srcdir="${DISTDIR}" \
		--with-lang="${LINGUAS_OOO}" \
		--with-num-cpus="${JOBS}" \
		--with-binsuffix="2" \
		--with-installed-ooo-dirname="openoffice" \
		"${GTKFLAG}" \
		`use_enable kde` \
		--disable-access \
		--disable-mono \
		--disable-cairo \
		--disable-post-install-scripts \
		--mandir=/usr/share/man \
		|| die "Configuration failed!"

	# Compile problems with these ...
	filter-flags "-funroll-loops"
	filter-flags "-fomit-frame-pointer"
	filter-flags "-fprefetch-loop-arrays"
	filter-flags "-fno-default-inline"
	filter-flags "-fstack-protector"
	filter-flags "-ftracer"
	append-flags "-fno-strict-aliasing"
	replace-flags "-O3" "-O2"
	replace-flags "-Os" "-O2"

	# Now for our optimization flags ...
	export ARCH_FLAGS="${CFLAGS}"

	einfo "Building OpenOffice.org..."
	use kde && set-kdedir 3
	make || die "Build failed"

}

src_install() {

	einfo "Preparing Installation"
	make DESTDIR=${D} install || die "Installation failed!"

	# Install corrected Symbol Font
	insinto /usr/share/fonts/TTF/
	doins fonts/*.ttf

}

pkg_postinst() {

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	[ -x /sbin/chpax ] && [ -e /usr/lib/openoffice/program/soffice.bin ] && chpax -zm /usr/lib/openoffice/program/soffice.bin

	einfo " To start OpenOffice.org, run:"
	einfo
	einfo " $ ooffice2"
	einfo
	einfo " Also, for individual components, you can use any of:"
	einfo
	einfo " oobase2, oocalc2, oodraw2, oofromtemplate2, ooimpress2, oomath2,"
	einfo " ooweb2 or oowriter2"
}
