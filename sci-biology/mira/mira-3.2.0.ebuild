# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/mira/mira-3.2.0.ebuild,v 1.3 2011/02/07 14:21:54 phajdan.jr Exp $

EAPI="3"

MIRA_3RDPARTY_PV="17-04-2010"

inherit autotools base multilib

DESCRIPTION="Whole Genome Shotgun and EST Sequence Assembler for Sanger, 454 and Solexa / Illumina"
HOMEPAGE="http://www.chevreux.org/projects_mira.html"
SRC_URI="mirror://sourceforge/mira-assembler/${P}.tar.bz2
	mirror://sourceforge/mira-assembler/mira_3rdparty_${MIRA_3RDPARTY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 x86 ~amd64-linux ~x86-linux ~x86-macos"

CDEPEND=">=dev-libs/boost-1.41.0-r3"
DEPEND="${CDEPEND}
	dev-libs/expat"
RDEPEND="${CDEPEND}"

src_prepare() {
	find -name 'configure*' -or -name 'Makefile*' | xargs sed -i 's/flex++/flex -+/' || die
	epatch "${FILESDIR}"/${PN}-3.0.0-asneeded.patch
	AT_M4DIR="config/m4" eautoreconf
}

src_configure() {
	econf \
		--with-boost="${EPREFIX}"/usr/$(get_libdir) \
		--with-boost-libdir="${EPREFIX}"/usr/$(get_libdir) \
		--with-boost-thread=boost_thread-mt
}

src_compile() {
	base_src_compile
	# TODO: resolve docbook incompatibility for building docs
	#if use doc; then emake -C doc clean docs || die; fi
}

src_install() {
	einstall || die
	dodoc AUTHORS GETTING_STARTED NEWS README* HELP_WANTED THANKS INSTALL
	find doc/docs/man -type f | xargs doman
	find doc/docs/texinfo -type f | xargs doinfo
	dobin "${WORKDIR}"/3rdparty/{sff_extract,qual2ball,*.pl}
}
