# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/perlmagick/perlmagick-5.5.7.14.ebuild,v 1.3 2004/04/25 21:07:48 vapier Exp $

inherit perl-module flag-o-matic eutils

# Left this the same as ImageMagick for the sake of simplicity
MY_PN=ImageMagick

MY_P=${MY_PN}-${PV%.*}-${PV#*.*.*.}
MY_P2=${MY_PN}-${PV%.*}

S=${WORKDIR}/${MY_P2}
DESCRIPTION="A Perl module to harness the powers of ImageMagick"
HOMEPAGE="http://www.imagemagick.org/"
SRC_URI="mirror://sourceforge/imagemagick/${MY_P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~mips ~alpha ~hppa"
IUSE=""

DEPEND="=media-gfx/imagemagick-${PV}*
	>=dev-lang/perl-5"

src_compile() {
	replace-cpu-flags i586 k6 k6-2 k6-3

	#patch to allow building by perl
	epatch ${FILESDIR}/perlpatch.diff || die

	cd PerlMagick
	perl-module_src_prep
	perl-module_src_compile
}

src_install() {
	cd PerlMagick
	perl-module_src_install
}
