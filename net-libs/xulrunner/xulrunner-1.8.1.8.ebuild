# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/xulrunner/xulrunner-1.8.1.8.ebuild,v 1.9 2007/10/23 17:28:35 corsair Exp $

WANT_AUTOCONF="2.1"

inherit flag-o-matic toolchain-funcs eutils makeedit multilib autotools mozconfig-2 java-pkg-opt-2
PATCH="${P}-patches-0.1"

DESCRIPTION="Mozilla runtime package that can be used to bootstrap XUL+XPCOM applications"
HOMEPAGE="http://developer.mozilla.org/en/docs/XULRunner"
SRC_URI="mirror://gentoo/${P}-source.tar.bz2
	mirror://gentoo/${PATCH}.tar.bz2"

SLOT="0"
LICENSE="MPL-1.1 GPL-2 LGPL-2.1"
KEYWORDS="alpha ~amd64 ~arm ~hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=sys-libs/zlib-1.1.4
	>=sys-devel/binutils-2.16.1
	>=dev-libs/nss-3.11.5
	>=dev-libs/nspr-4.6.5-r1
	java? ( >=virtual/jre-1.4 )"

DEPEND="java? ( >=virtual/jdk-1.4 )
	${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/mozilla"

# Needed by src_compile() and src_install().
# Would do in pkg_setup but that loses the export attribute, they
# become pure shell variables.
export MOZ_CO_PROJECT=xulrunner
export BUILD_OFFICIAL=1
export MOZILLA_OFFICIAL=1

src_unpack() {
	unpack ${P}-source.tar.bz2  ${PATCH}.tar.bz2

	# Apply our patches
	cd "${S}" || die "cd failed"
	EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" \
	epatch "${WORKDIR}"/patch

	eautoreconf || die "failed  running eautoreconf"
}

src_compile() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	####################################
	#
	# mozconfig, CFLAGS and CXXFLAGS setup
	#
	####################################

	mozconfig_init
	mozconfig_config

	mozconfig_annotate '' --enable-extensions="default,cookie,permissions,spellcheck"
	mozconfig_annotate '' --enable-native-uconv
	mozconfig_annotate '' --enable-image-encoder=all
	mozconfig_annotate '' --enable-canvas
	#mozconfig_annotate '' --enable-js-binary
	mozconfig_annotate '' --enable-embedding-tests
	mozconfig_annotate '' --with-system-nspr
	mozconfig_annotate '' --with-system-nss
	mozconfig_annotate '' --with-system-bz2
	mozconfig_annotate '' --enable-jsd
	mozconfig_annotate '' --enable-xpctools
	# Bug 60668: Galeon doesn't build without oji enabled, so enable it
	# regardless of java setting.
	mozconfig_annotate '' --enable-oji --enable-mathml
	mozconfig_annotate '' --with-default-mozilla-five-home=${MOZILLA_FIVE_HOME}

	#disable java
	if ! use java ; then
		mozconfig_annotate '-java' --disable-javaxpcom
	fi

	# Finalize and report settings
	mozconfig_final

	# -fstack-protector breaks us
	if gcc-version ge 4 1; then
		gcc-specs-ssp && append-flags -fno-stack-protector
	else
		gcc-specs-ssp && append-flags -fno-stack-protector-all
	fi
	filter-flags -fstack-protector -fstack-protector-all

	####################################
	#
	#  Configure and build
	#
	####################################

	CPPFLAGS="${CPPFLAGS} -DARON_WAS_HERE" \
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getLD)" \
	econf || die

	# It would be great if we could pass these in via CPPFLAGS or CFLAGS prior
	# to econf, but the quotes cause configure to fail.
	sed -i -e \
		's|-DARON_WAS_HERE|-DGENTOO_NSPLUGINS_DIR=\\\"/usr/'"$(get_libdir)"'/nsplugins\\\" -DGENTOO_NSBROWSER_PLUGINS_DIR=\\\"/usr/'"$(get_libdir)"'/nsbrowser/plugins\\\"|' \
		${S}/config/autoconf.mk \
		${S}/toolkit/content/buildconfig.html

	# This removes extraneous CFLAGS from the Makefiles to reduce RAM
	# requirements while compiling
	edit_makefiles

	emake || die "emake failed"
}

src_install() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"
	emake DESTDIR="${D}" install || die "emake install failed"
	X_DATE=`date +%Y%m%d`

	# Add Gentoo package version to preferences - copied from debian rules
	echo // Gentoo package version \
		> ${D}/usr/$(get_libdir)/xulrunner/defaults/pref/vendor.js
	echo "pref(\"general.useragent.product\",\"Gecko\");" \
		>> ${D}/usr/$(get_libdir)/xulrunner/defaults/pref/vendor.js
	echo "pref(\"general.useragent.productSub\",\"${X_DATE}\");" \
		>> ${D}/usr/$(get_libdir)/xulrunner/defaults/pref/vendor.js
	echo "pref(\"general.useragent.productComment\",\"Gentoo\");" \
		>> ${D}/usr/$(get_libdir)/xulrunner/defaults/pref/vendor.js

	if use java ; then
	    java-pkg_dojar ${D}${MOZILLA_FIVE_HOME}/javaxpcom.jar
	    rm -f ${D}${MOZILLA_FIVE_HOME}/javaxpcom.jar
	fi

	# xulrunner registration, the gentoo way
	insinto /etc/gre.d
	newins ${FILESDIR}/${PN}.conf ${PV}.conf
	sed -i -e \
		"s|version|${PV}|
			s|instpath|${MOZILLA_FIVE_HOME}|" \
		${D}/etc/gre.d/${PV}.conf
}

pkg_postinst() {
	elog "Please remember to rebuild any packages that you have built"
	elog "against xulrunner. Some packages might be broken by the upgrade; if this"
	elog "is the case, please search at http://bugs.gentoo.org and open a new bug"
	elog "if one does not exist."
}
