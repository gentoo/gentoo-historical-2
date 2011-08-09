# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/bibtexu/bibtexu-3.71_p20110627.ebuild,v 1.3 2011/08/09 20:50:51 hwoarang Exp $

EAPI=3

inherit eutils

DESCRIPTION="8-bit Implementation of BibTeX 0.99 with a Very Large Capacity"
HOMEPAGE="http://tug.org/texlive/"
SRC_URI="mirror://gentoo/texlive-${PV#*_p}-source.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="dev-libs/kpathsea
		>=dev-libs/icu-4.4"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/texlive-${PV#*_p}-source/texk/${PN}

src_prepare() {
	epatch "${FILESDIR}/${P}-invoc_name.patch"
}

src_configure() {
	econf --with-system-kpathsea \
		--with-system-icu
}

src_install() {
	emake \
		DESTDIR="${D}" \
		csfdir="${EPREFIX}/usr/share/texmf-dist/bibtexu/csf/base" \
		btdocdir="${EPREFIX}/usr/share/doc/${PF}" \
		install || die
	dodoc 00readme.txt ChangeLog csfile.txt HISTORY || die
}
