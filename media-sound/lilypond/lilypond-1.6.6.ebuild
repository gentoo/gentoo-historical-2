# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/lilypond/lilypond-1.6.6.ebuild,v 1.8 2003/09/07 00:06:05 msterret Exp $

inherit gcc

MY_PV="v$(echo ${PV} | cut -d. -f1,2)"
DESCRIPTION="GNU Music Typesetter"
HOMEPAGE="http://lilypond.org/"
SRC_URI="http://www.lilypond.org/ftp/${MY_PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 alpha"
IUSE="doc"

DEPEND=">=dev-lang/python-2.2.1-r2
	>=dev-lang/perl-5.6.1-r6
	>=dev-util/guile-1.4-r3
	>=sys-devel/bison-1.35
	>=app-text/tetex-1.0.7-r12
	>=sys-apps/texinfo-4.2-r5
	>=sys-devel/flex-2.5.4a-r5
	doc? ( >=app-text/mftrace-1.0.8
		>=app-text/ghostscript-7.05.5
		>=media-libs/netpbm-9.12-r2 )"
RDEPEND=">=dev-util/guile-1.4-r3
	>=app-text/ghostscript-7.05.5
	>=app-text/tetex-1.0.7-r10
	>=dev-lang/python-2.2.1-r2"

src_compile() {
	# See http://lilypond.org/stable/Documentation/topdocs/out-www/INSTALL.html
	local flex_version=`flex --version | cut -d' ' -f2`
	case "$(gcc-version):${flex_version}" in
		2.*:*)
			# Verified by agriffis 03 Dec 2002 using
			# gcc-2.95.3-r7 with flex-2.5.4a-r5
			# (i.e. Gentoo 1.2)
			./configure --build=${CHOST} --prefix=/usr || die "configure failed"
			emake || die "emake failed"
			;;

		3.0:*)
			# Unverified
			./configure --build=${CHOST} --prefix=/usr || die "configure failed"
			make -C lily out/lexer.cc
			( cd out; patch -p1 < ../lexer-gcc-3.0.patch; )
			emake || die "emake failed"
			;;

		3.1:*)
			# Unverified
			./lexer-gcc-3.1.sh
			CPPFLAGS=-I$(pwd)/lily/out ./configure || die "configure failed"
			./lexer-gcc-3.1.sh
			emake || die "emake failed"
			;;

		# Note the following is the DEFAULT if there was no match,
		# i.e. for gcc >= 3.2
		3.2:*|*)
			# Verified by agriffis 03 Dec 2002 using
			# gcc-3.2.1 with flex-2.5.4a and flex-2.5.23
			./configure --build=${CHOST} --prefix=/usr || die "configure failed"
			# Fix std::cerr problem in flex 2.5.4a and 2.5.23
			make -C lily out/lexer.cc
			perl -i -pe 's/\scerr\s/ std::cerr /g' lily/out/lexer.cc
			emake || die "emake failed"
			;;
	esac
	#use doc && make web-doc || "make web-doc failed"
}

src_install () {
	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		datadir=${D}/usr/share \
		lilypond_datadir=${D}/usr/share/lilypond \
		local_lilypond_datadir=${D}/usr/share/lilypond/${PV} \
		install || die "make install failed"
	dodoc AUTHORS* COPYING ChangeLog DEDICATION NEWS README.txt \
		ROADMAP THANKS VERSION *.el
	insinto /usr/share/lilypond/${PV}/buildscripts/out
	doins buildscripts/out/lilypond-profile \
		buildscripts/out/lilypond-login \
		buildscripts/out/clean-fonts
}

pkg_postinst () {
	# Cleaning out old fonts is more appropriate in pkg_prerm, but we
	# also need to clean up after any lilypond installations which may
	# not have been installed via portage.
	. /usr/share/lilypond/${PV}/buildscripts/out/clean-fonts
}

pkg_prerm () {
	. /usr/share/lilypond/${PV}/buildscripts/out/clean-fonts
}
