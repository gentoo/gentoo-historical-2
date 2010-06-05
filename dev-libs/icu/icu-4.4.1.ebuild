# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/icu/icu-4.4.1.ebuild,v 1.3 2010/06/05 21:36:14 arfrever Exp $

EAPI="3"

inherit flag-o-matic versionator

MAJOR_MINOR_VERSION="$(get_version_component_range 1-2)"

DESCRIPTION="International Components for Unicode"
HOMEPAGE="http://www.icu-project.org/"

BASE_URI="http://download.icu-project.org/files/icu4c/${PV}"
DOCS_BASE_URI="http://download.icu-project.org/files/icu4c/${MAJOR_MINOR_VERSION}"
SRC_ARCHIVE="icu4c-${PV//./_}-src.tgz"
DOCS_ARCHIVE="icu4c-${MAJOR_MINOR_VERSION//./_}-docs.zip"

SRC_URI="${BASE_URI}/${SRC_ARCHIVE}
	doc? ( ${DOCS_BASE_URI}/${DOCS_ARCHIVE} )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE="debug doc examples"

DEPEND="doc? ( app-arch/unzip )"
RDEPEND=""

S="${WORKDIR}/${PN}/source"

QA_DT_NEEDED="/usr/lib.*/libicudata.so.${MAJOR_MINOR_VERSION/./}.0"

src_unpack() {
	unpack "${SRC_ARCHIVE}"
	if use doc; then
		mkdir docs
		pushd docs > /dev/null
		unpack "${DOCS_ARCHIVE}"
		popd > /dev/null
	fi
}

src_prepare() {
	# Do not hardcode used CFLAGS, LDFLAGS etc. into icu-config
	# Bug 202059
	# https://bugs.icu-project.org/trac/ticket/6102
	for x in ARFLAGS CFLAGS CPPFLAGS CXXFLAGS FFLAGS LDFLAGS; do
		sed -i -e "/^${x} =.*/s:@${x}@::" "config/Makefile.inc.in" || die "sed failed"
	done
}

src_configure() {
	econf \
		--enable-static \
		$(use_enable debug) \
		$(use_enable examples samples)
}

src_test() {
	emake check || die "emake check failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dohtml ../readme.html
	dodoc ../unicode-license.txt
	if use doc; then
		insinto /usr/share/doc/${PF}/html/api
		doins -r "${WORKDIR}/docs/"*
	fi
}
