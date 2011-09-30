# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/libreoffice/libreoffice-9999-r1.ebuild,v 1.30 2011/09/30 10:45:08 scarabeus Exp $

EAPI=3

KDE_REQUIRED="optional"
KDE_SCM="git"
CMAKE_REQUIRED="never"

PYTHON_DEPEND="2"
PYTHON_USE_WITH="threads,xml"

# experimental ; release ; old
# Usually the tarballs are moved a lot so this should make
# everyone happy.
DEV_URI="
	http://dev-builds.libreoffice.org/pre-releases/src
	http://download.documentfoundation.org/libreoffice/src
	http://download.documentfoundation.org/libreoffice/old/src
"
EXT_URI="http://ooo.itc.hu/oxygenoffice/download/libreoffice"
ADDONS_URI="http://dev-www.libreoffice.org/src/"

BRANDING="${PN}-branding-gentoo-0.3.tar.xz"

[[ ${PV} == *9999* ]] && SCM_ECLASS="git-2"
inherit base autotools bash-completion-r1 check-reqs eutils java-pkg-opt-2 kde4-base pax-utils prefix python multilib toolchain-funcs flag-o-matic nsplugins ${SCM_ECLASS}
unset SCM_ECLASS

DESCRIPTION="LibreOffice, a full office productivity suite."
HOMEPAGE="http://www.libreoffice.org"
SRC_URI="branding? ( http://dev.gentooexperimental.org/~scarabeus/${BRANDING} )"

# Split modules following git/tarballs
# Core MUST be first!
MODULES="core binfilter dictionaries help"
# Only release has the tarballs
if [[ ${PV} != *9999* ]]; then
	for i in ${DEV_URI}; do
		for mod in ${MODULES}; do
			SRC_URI+=" ${i}/${PN}-${mod}-${PV}.tar.bz2"
		done
		unset mod
	done
	unset i
fi
unset DEV_URI

# Really required addons
# These are bundles that can't be removed for now due to huge patchsets.
# If you want them gone, patches are welcome.
ADDONS_SRC+=" ${ADDONS_URI}/fdb27bfe2dbe2e7b57ae194d9bf36bab-SampleICC-1.3.2.tar.gz"
ADDONS_SRC+=" nsplugin? ( ${ADDONS_URI}/1f24ab1d39f4a51faf22244c94a6203f-xmlsec1-1.2.14.tar.gz )"
ADDONS_SRC+=" java? ( ${ADDONS_URI}/17410483b5b5f267aa18b7e00b65e6e0-hsqldb_1_8_0.zip )"
SRC_URI+=" ${ADDONS_SRC}"

TDEPEND="${EXT_URI}/472ffb92d82cf502be039203c606643d-Sun-ODF-Template-Pack-en-US_1.0.0.oxt"
TDEPEND+=" linguas_de? ( ${EXT_URI}/53ca5e56ccd4cab3693ad32c6bd13343-Sun-ODF-Template-Pack-de_1.0.0.oxt )"
TDEPEND+=" linguas_en_GB? ( ${EXT_URI}/472ffb92d82cf502be039203c606643d-Sun-ODF-Template-Pack-en-US_1.0.0.oxt )"
TDEPEND+=" linguas_en_ZA? ( ${EXT_URI}/472ffb92d82cf502be039203c606643d-Sun-ODF-Template-Pack-en-US_1.0.0.oxt )"
TDEPEND+=" linguas_es? ( ${EXT_URI}/4ad003e7bbda5715f5f38fde1f707af2-Sun-ODF-Template-Pack-es_1.0.0.oxt )"
TDEPEND+=" linguas_fr? ( ${EXT_URI}/a53080dc876edcddb26eb4c3c7537469-Sun-ODF-Template-Pack-fr_1.0.0.oxt )"
TDEPEND+=" linguas_hu? ( ${EXT_URI}/09ec2dac030e1dcd5ef7fa1692691dc0-Sun-ODF-Template-Pack-hu_1.0.0.oxt )"
TDEPEND+=" linguas_it? ( ${EXT_URI}/b33775feda3bcf823cad7ac361fd49a6-Sun-ODF-Template-Pack-it_1.0.0.oxt )"
SRC_URI+=" templates? ( ${TDEPEND} )"

unset ADDONS_URI
unset EXT_URI
unset ADDONS_SRC

IUSE="binfilter +branding dbus debug eds gnome +graphite gstreamer gtk +jemalloc
kde ldap mysql nsplugin odk opengl pdfimport svg templates test +vba webdav"
LICENSE="LGPL-3"
SLOT="0"
[[ ${PV} == *9999* ]] || KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"

# lingua for templates
LANGUAGES="de en_GB en_ZA es fr hu it"
for X in ${LANGUAGES} ; do
	IUSE+=" linguas_${X}"
done
unset X

COMMON_DEPEND="
	app-arch/zip
	app-arch/unzip
	>=app-text/hunspell-1.3.2
	app-text/mythes
	>=app-text/libtextcat-3.1
	app-text/libwpd:0.9[tools]
	app-text/libwpg:0.2
	>=app-text/libwps-0.2.2
	dev-db/unixODBC
	dev-libs/expat
	>=dev-libs/glib-2.18
	>=dev-libs/hyphen-2.7.1
	>=dev-libs/icu-4.8.1-r1
	>=dev-lang/perl-5.0
	>=dev-libs/openssl-0.9.8g
	dev-libs/redland[ssl]
	>=dev-python/translate-toolkit-1.8.0
	>=media-libs/fontconfig-2.3.0
	media-libs/freetype:2
	>=media-libs/libpng-1.4
	media-libs/libvisio
	net-print/cups
	sci-mathematics/lpsolve
	>=sys-libs/db-4.8
	virtual/jpeg
	>=x11-libs/cairo-1.10.0
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	dbus? ( >=dev-libs/dbus-glib-0.94 )
	eds? ( gnome-extra/evolution-data-server )
	gnome? ( gnome-base/gconf:2 )
	gtk? ( >=x11-libs/gtk+-2.24:2 )
	graphite? ( media-gfx/graphite2 )
	gstreamer? (
		>=media-libs/gstreamer-0.10
		>=media-libs/gst-plugins-base-0.10
	)
	java? (
		>=dev-java/bsh-2.0_beta4
		dev-java/lucene:2.9
		dev-java/lucene-analyzers:2.3
		dev-java/saxon:0
	)
	jemalloc? ( dev-libs/jemalloc )
	ldap? ( net-nds/openldap )
	mysql? ( >=dev-db/mysql-connector-c++-1.1.0 )
	nsplugin? (
		net-libs/xulrunner:1.9
		>=dev-libs/nspr-4.8.8
		>=dev-libs/nss-3.12.9
	)
	opengl? ( virtual/opengl )
	pdfimport? ( >=app-text/poppler-0.12.3-r3[xpdf-headers] )
	svg? ( gnome-base/librsvg )
	webdav? ( net-libs/neon )
"

RDEPEND="${COMMON_DEPEND}
	!app-office/libreoffice-bin
	!app-office/openoffice-bin
	!app-office/openoffice
	media-fonts/libertine-ttf
	media-fonts/liberation-fonts
	java? ( >=virtual/jre-1.6 )
"

# FIXME: l10n after release/branching
PDEPEND="
	>=app-office/libreoffice-l10n-3.4
"

# FIXME: cppunit should be moved to test conditional
#        after everything upstream is under gbuild
#        as dmake execute tests right away
DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.46
	>=dev-libs/libxml2-2.7.8
	dev-libs/libxslt
	dev-perl/Archive-Zip
	dev-util/cppunit
	>=dev-util/gperf-3
	dev-util/intltool
	dev-util/mdds
	>=dev-util/pkgconfig-0.26
	>=media-libs/vigra-1.7
	>=net-misc/curl-7.21.7
	>=sys-apps/findutils-4.5.9
	sys-devel/bison
	sys-apps/coreutils
	sys-devel/flex
	sys-devel/gettext
	>=sys-devel/make-3.82
	sys-libs/zlib
	x11-libs/libXtst
	x11-proto/randrproto
	x11-proto/xextproto
	x11-proto/xineramaproto
	x11-proto/xproto
	java? (
		=virtual/jdk-1.6*
		>=dev-java/ant-core-1.7
		test? ( dev-java/junit:4 )
	)
"

PATCHES=(
)

# Uncoment me when updating to eapi4
# REQUIRED_USE="
#	|| ( gtk gnome kde )
#	gnome? ( gtk )
#	nsplugin? ( gtk )
#"

S="${WORKDIR}/${PN}-core-${PV}"

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	kde4-base_pkg_setup

	python_set_active_version 2
	python_pkg_setup

	if [[ $(gcc-major-version) -lt 4 ]]; then
		eerror "Compilation with gcc older than 4.0 is not supported"
		die "Too old gcc found."
	fi

	if ! use gtk; then
		ewarn "If you want the LibreOffice systray quickstarter to work"
		ewarn "activate the 'gtk' use flag."
		ewarn
	fi

	# Check if we have enough RAM and free diskspace to build this beast
	CHECKREQS_MEMORY="1G"
	use debug && CHECKREQS_DISK_BUILD="15G" || CHECKREQS_DISK_BUILD="9G"
	check-reqs_pkg_setup
}

src_unpack() {
	local mod dest tmplfile tmplname mypv

	if use branding; then
		unpack "${BRANDING}"
	fi

	if [[ ${PV} != *9999* ]]; then
		for mod in ${MODULES}; do
			unpack "${PN}-${mod}-${PV}.tar.bz2"
			if [[ ${mod} != core ]]; then
				mv -n "${WORKDIR}/${PN}-${mod}-${PV}"/* "${S}"
				rm -rf "${WORKDIR}/${PN}-${mod}-${PV}"
			fi
		done
	else
		for mod in ${MODULES}; do
			mypv=${PV/.9999}
			[[ ${mypv} != ${PV} ]] && EGIT_BRANCH="${PN}-${mypv/./-}"
			EGIT_PROJECT="${PN}/${mod}"
			EGIT_SOURCEDIR="${WORKDIR}/${PN}-${mod}-${PV}"
			EGIT_REPO_URI="git://anongit.freedesktop.org/${PN}/${mod}"
			EGIT_NOUNPACK="true"
			git-2_src_unpack
			if [[ ${mod} != core ]]; then
				mv -n "${WORKDIR}/${PN}-${mod}-${PV}"/* "${S}"
				rm -rf "${WORKDIR}/${PN}-${mod}-${PV}"
			fi
		done
		unset EGIT_PROJECT EGIT_SOURCEDIR EGIT_REPO_URI EGIT_BRANCH
	fi

	# copy extension templates; o what fun ...
	if use templates; then
		dest="${S}/extras/source/extensions"
		mkdir -p "${dest}"

		for template in ${TDEPEND}; do
			if [[ ${template} == *.oxt ]]; then
				tmplfile="${DISTDIR}/$(basename ${template})"
				tmplname="$(echo "${template}" | \
					cut -f 2- -s -d - | cut -f 1 -d _)"
				echo ">>> Unpacking ${tmplfile/\*/} to ${dest}"
				if [[ -f ${tmplfile} && ! -f "${dest}/${tmplname}.oxt" ]]; then
					cp -v "${tmplfile}" "${dest}/${tmplname}.oxt" || die
				fi
			fi
		done
	fi
}

src_prepare() {
	# optimization flags
	export ARCH_FLAGS="${CXXFLAGS}"
	export LINKFLAGSOPTIMIZE="${LDFLAGS}"

	base_src_prepare
	eautoreconf
	# hack in the autogen.sh
	touch autogen.lastrun
}

src_configure() {
	local java_opts
	local internal_libs
	local themes="crystal"
	local jbs=$(sed -ne 's/.*\(-j[[:space:]]*\|--jobs=\)\([[:digit:]]\+\).*/\2/;T;p' <<< "${MAKEOPTS}")

	# recheck that there is some value in jobs
	[[ -z ${jbs} ]] && jbs="1"

	# expand themes we are going to build based on DE useflags
	use gnome && themes+=" tango"
	use kde && themes+=" oxygen"

	# sane: just sane.h header that is used for scan in writer, not
	#       linked or anything else, worthless to depend on
	internal_libs+="
		--without-system-sane
	"

	if use java; then
		java_opts="
			--without-system-hsqldb
			--with-ant-home="${ANT_HOME}"
			--with-jdk-home=$(java-config --jdk-home 2>/dev/null)
			--with-java-target-version=$(java-pkg_get-target)
			--with-jvm-path="${EPREFIX}/usr/$(get_libdir)/"
			--with-beanshell-jar=$(java-pkg_getjar bsh bsh.jar)
			--with-lucene-core-jar=$(java-pkg_getjar lucene-2.9 lucene-core.jar)
			--with-lucene-analyzers-jar=$(java-pkg_getjar lucene-analyzers-2.3 lucene-analyzers.jar)
			--with-saxon-jar=$(java-pkg_getjar saxon saxon8.jar)
		"
		if use test; then
			java_opts+=" --with-junit=$(java-pkg_getjar junit-4 junit.jar)"
		else
			java_opts+=" --without-junit"
		fi
	fi

	if use branding; then
		internal_libs+="
			--with-about-bitmap="${WORKDIR}/branding-about.png"
			--with-intro-bitmap="${WORKDIR}/branding-intro.png"
		"
	fi

	# system headers/libs/...: enforce using system packages
	#   only expections are mozilla and odbc/sane/xrender-header(s).
	#   for jars the exception is db.jar controlled by --with-system-db
	# --enable-unix-qstart-libpng: use libpng splashscreen that is faster
	# --enable-cairo: ensure that cairo is always required
	# --enable-*-link: link to the library rather than just dlopen on runtime
	# --enable-release-build: build the libreoffice as release
	# --disable-fetch-external: prevent dowloading during compile phase
	# --disable-gnome-vfs: old gnome virtual fs support
	# --disable-kdeab: kde3 adressbook
	# --disable-kde: kde3 support
	# --disable-pch: precompiled headers cause build crashes
	# --disable-rpath: relative runtime path is not desired
	# --disable-static-gtk: ensure that gtk is linked dynamically
	# --disable-ugly: disable ugly pieces of code
	# --disable-zenity: disable build icon
	# --enable-extension-integration: enable any extension integration support
	# --with-{max-jobs,num-cpus}: ensuring parallel building
	# --without-{afms,fonts,myspell-dicts,ppsd}: prevent install of sys pkgs
	# --without-stlport: disable deprecated extensions framework
	# --disable-ext-report-builder: too much java packages pulled in
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}/" \
		--with-system-headers \
		--with-system-libs \
		--with-system-jars \
		--with-system-db \
		--with-system-dicts \
		--with-system-libvisio \
		--with-system-libexttextcat \
		--with-system-translate-toolkit \
		--enable-cairo-canvas \
		--enable-largefile \
		--enable-python=system \
		--enable-randr \
		--enable-randr-link \
		--enable-release-build \
		--enable-unix-qstart-libpng \
		--enable-xrender-link \
		--disable-crashdump \
		--disable-dependency-tracking \
		--disable-epm \
		--disable-fetch-external \
		--disable-gnome-vfs \
		--disable-ext-report-builder \
		--disable-kdeab \
		--disable-kde \
		--disable-online-update \
		--disable-pch \
		--disable-rpath \
		--disable-static-gtk \
		--disable-strip-solver \
		--disable-ugly \
		--disable-zenity \
		--with-alloc=$(use jemalloc && echo "jemalloc" || echo "system") \
		--with-build-version="Gentoo official package" \
		--enable-extension-integration \
		--with-external-dict-dir="${EPREFIX}/usr/share/myspell" \
		--with-external-hyph-dir="${EPREFIX}/usr/share/myspell" \
		--with-external-thes-dir="${EPREFIX}/usr/share/myspell" \
		--with-external-tar="${DISTDIR}" \
		--with-lang="" \
		--with-max-jobs=${jbs} \
		--with-num-cpus=${jbs} \
		--with-theme="${themes}" \
		--with-unix-wrapper=libreoffice \
		--with-vendor="Gentoo Foundation" \
		--with-x \
		--without-afms \
		--without-fonts \
		--without-myspell-dicts \
		--without-ppds \
		--without-stlport \
		--without-helppack-integration \
		$(use_enable binfilter) \
		$(use_enable dbus) \
		$(use_enable debug crashdump) \
		$(use_enable eds evolution2) \
		$(use_enable gnome gconf) \
		$(use_enable gnome gio) \
		$(use_enable gnome lockdown) \
		$(use_enable graphite) \
		$(use_enable gstreamer) \
		$(use_enable gtk) \
		$(use_enable gtk gtk3) \
		$(use_enable gtk systray) \
		$(use_enable java ext-scripting-beanshell) \
		$(use_enable kde kde4) \
		$(use_enable ldap) \
		$(use_enable mysql ext-mysql-connector) \
		$(use_enable nsplugin mozilla) \
		$(use_enable odk) \
		$(use_enable opengl) \
		$(use_enable pdfimport ext-pdfimport) \
		$(use_enable svg librsvg system) \
		$(use_enable vba) \
		$(use_enable vba activex-component) \
		$(use_enable webdav neon) \
		$(use_with java) \
		$(use_with ldap openldap) \
		$(use_with mysql system-mysql-cppconn) \
		$(use_with nsplugin system-mozilla libxul) \
		$(use_with templates sun-templates) \
		${internal_libs} \
		${java_opts}
}

src_compile() {
	# this is not a proper make script and the jobs are passed during configure
	make build || die
}

src_test() {
	make check || die
}

src_install() {
	# This is not Makefile so no buildserver
	make DESTDIR="${D}" distro-pack-install -o build -o check || die

	# Fix bash completion placement
	newbashcomp "${ED}"/etc/bash_completion.d/libreoffice.sh ${PN} || die
	rm -rf "${ED}"/etc/

	# symlink the plugin to system location
	if use nsplugin; then
		inst_plugin /usr/$(get_libdir)/libreoffice/program/libnpsoplugin.so
	fi

	if use branding; then
		insinto /usr/$(get_libdir)/${PN}/program
		newins "${WORKDIR}/branding-sofficerc" sofficerc || die
	fi
}

pkg_preinst() {
	# Cache updates - all handled by kde eclass for all environments
	kde4-base_pkg_preinst
}

pkg_postinst() {
	kde4-base_pkg_postinst

	pax-mark -m "${EPREFIX}"/usr/$(get_libdir)/libreoffice/program/soffice.bin
}

pkg_postrm() {
	kde4-base_pkg_postrm
}
