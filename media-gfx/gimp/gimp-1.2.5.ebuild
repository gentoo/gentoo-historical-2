# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gimp/gimp-1.2.5.ebuild,v 1.13 2004/01/14 18:34:08 gustavoz Exp $

inherit eutils flag-o-matic

IUSE="python nls gnome aalib perl doc jpeg png tiff"

DESCRIPTION="The GIMP"
SRC_URI="mirror://gimp/v1.2/v${PV}/${P}.tar.bz2"
HOMEPAGE="http://www.gimp.org/"

SLOT="1.2"
KEYWORDS="x86 ~ppc sparc ~alpha amd64 hppa"
LICENSE="GPL-2"

RDEPEND="=x11-libs/gtk+-1.2*
	aalib? ( >=media-libs/aalib-1.2 )
	perl? ( >=dev-perl/PDL-2.2.1
		>=dev-perl/Parse-RecDescent-1.80
		>=dev-perl/gtk-perl-0.7004 )
	python? ( >=dev-lang/python-2.0 )
	gnome? ( >=gnome-base/gnome-libs-1.4.1.2-r1 )
	tiff? ( media-libs/tiff )
	jpeg ( media-libs/jpeg )
	png? ( media-libs/libpng )"

DEPEND="nls? ( sys-devel/gettext )
	doc? ( dev-util/gtk-doc )
	>=media-libs/mpeg-lib-1.3.1
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	# here for a mysterious reason
	touch ${S}/plug-ins/common/${P}.tar.bz2
}

src_compile() {
	# fix problem with k6's (#22115)
	replace-flags -march=k6-2 -march=i586
	replace-flags -march=k6-3 -march=i586
	replace-flags -march=k6 -march=i586
	# over-optimisations (#21787)
	replace-flags -Os -O2
	# gimp has inline functions (plug-ins/common/grid.c) (#23078)
	filter-flags "-fno-inline"

	local mymake=""
	local AA

	use aalib || mymake="LIBAA= AA="
	use gnome || mymake="${mymake} HELPBROWSER="
	use perl && export PERL_MM_OPT=' PREFIX=${D}/usr'

	econf \
		--with-mp \
		--with-threads \
		--disable-debug \
		--disable-print \
		`use_enable perl` \
		`use_enable python` \
		`use_enable nls` \
		`use_with jpeg libjpeg` \
		`use_with png libpng` \
		`use_with tiff libtiff` \
		`use_enable doc gtk-doc` \
		${myconf} || die

	if [ -z "`use aalib`" ] ; then
		# Horrible automake brokenness
		cp plug-ins/common/Makefile plug-ins/common/Makefile.orig
		cat plug-ins/common/Makefile.orig | \
			sed 's/CML_explorer$(EXEEXT) aa/CML_explorer$(EXEEXT)/' \
			> plug-ins/common/Makefile
	fi

	MAKEOPTS="${MAKEOPTS} -j1"
	# see bug #21924
	CFLAGS="${CFLAGS} /usr/lib/libmpeg.a"

	emake ${mymake} || die
}

src_install() {

	local mymake=""
	local AA

	use aalib || mymake="LIBAA= AA="
	use gnome || mymake="${mymake} HELPBROWSER="

	dodir /usr/lib/gimp/1.2/plug-ins

	einstall \
		gimpdatadir=${D}/usr/share/gimp/1.2 \
		gimpsysconfdir=${D}/etc/gimp/1.2 \
		PREFIX=${D}/usr \
		INSTALLPRIVLIB=${D}/usr/lib/perl5 \
		INSTALLSCRIPT=${D}/usr/bin \
		INSTALLSITELIB=${D}/usr/lib/perl5/site_perl \
		INSTALLBIN=${D}/usr/bin \
		INSTALLMAN1DIR=${D}/usr/share/man/man1 \
		INSTALLMAN3DIR=${D}/usr/share/man/man3 \
		INSTALLSITEMAN1DIR=${D}/usr/share/man/man1 \
		INSTALLSITEMAN3DIR=${D}/usr/share/man/man3pm \
		INSTALLVENDORMAN1DIR=${D}/usr/share/man/man1 \
		INSTALLVENDORMAN3DIR=${D}/usr/share/man/man3pm \
		${mymake} || die "Installation failed"

	dosym gimp-1.2 /usr/bin/gimp
	#this next line closes bug #810
	dosym gimptool-1.2 /usr/bin/gimptool

	use gnome && (
		insinto /usr/share/applications
		doins ${FILESDIR}/gimp.desktop
	)

	preplib /usr

	dodoc AUTHORS COPYING ChangeLog* *MAINTAINERS README* TODO
	dodoc docs/*.txt docs/*.ps docs/Wilber* docs/quick_reference.tar.gz
}
