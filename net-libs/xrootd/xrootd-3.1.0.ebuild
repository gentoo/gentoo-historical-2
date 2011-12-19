# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/xrootd/xrootd-3.1.0.ebuild,v 1.1 2011/12/19 19:36:35 bicatali Exp $

EAPI=4

inherit cmake-utils eutils

DURI="http://xrootd.slac.stanford.edu/doc/prod"

DESCRIPTION="Extended ROOT remote file server"
HOMEPAGE="http://xrootd.org/"
SRC_URI="${HOMEPAGE}/download/v${PV}/${P}.tar.gz
		 doc? (
			${DURI}/Syntax_config.pdf
			${DURI}/xrd_config.pdf
			${DURI}/ofs_config.pdf
			${DURI}/cms_config.pdf
			${DURI}/sec_config.pdf
			${DURI}/xrd_monitoring.pdf
			${DURI}/frm_config.pdf
			${DURI}/XRdv297.pdf
		 )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc fuse kerberos perl readline ssl"

RDEPEND="!<sci-physics/root-5.32[xrootd]
	sys-libs/zlib
	fuse? ( sys-fs/fuse )
	kerberos? ( virtual/krb5 )
	perl? (
		dev-lang/perl
		readline? ( dev-perl/Term-ReadLine-Perl )
	)
	readline? ( sys-libs/readline )
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	perl? ( dev-lang/swig )"

pkg_setup() {
	enewgroup xrootd
	enewuser xrootd -1 -1 "${EPREFIX}"/var/spool/xrootd xrootd
}

src_configure() {
#		"-DCMAKE_BUILD_TYPE=Release"
	mycmakeargs=(
		$(cmake-utils_use_enable fuse)
		$(cmake-utils_use_enable kerberos KRB5)
		$(cmake-utils_use_enable perl)
		$(cmake-utils_use_enable readline)
		$(cmake-utils_use_enable ssl CRYPTO)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# base configs
	insinto /etc/xrootd
	doins packaging/common/*.cfg

	# create aux dirs and correct permissions so that xrootd
	# will be happy as a non-priviledged user
	fowners root:xrootd "${EPREFIX}"/etc/xrootd
	keepdir "${EPREFIX}"/var/log/xrootd
	keepdir "${EPREFIX}"/var/run/xrootd
	keepdir "${EPREFIX}"/var/spool/xrootd
	fowners xrootd:xrootd "${EPREFIX}"/var/{log,run,spool}/xrootd

	local i
	for i in cmsd frm_purged frm_xfrd xrootd; do
		newinitd "${FILESDIR}"/${i}.initd ${i}
	done
	# all daemons MUST use single master config file
	newconfd "${FILESDIR}"/xrootd.confd xrootd

	dodoc docs/ReleaseNotes.txt
	use doc && \
		dodoc \
			"${DISTDIR}"/Syntax_config.pdf \
			"${DISTDIR}"/xrd_config.pdf \
			"${DISTDIR}"/ofs_config.pdf \
			"${DISTDIR}"/cms_config.pdf \
			"${DISTDIR}"/sec_config.pdf \
			"${DISTDIR}"/xrd_monitoring.pdf \
			"${DISTDIR}"/frm_config.pdf \
			"${DISTDIR}"/XRdv297.pdf
}
