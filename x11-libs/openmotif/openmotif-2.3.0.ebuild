# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/openmotif/openmotif-2.3.0.ebuild,v 1.18 2008/02/16 16:17:20 ulm Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="1.6"

inherit eutils libtool flag-o-matic multilib autotools

DESCRIPTION="Open Motif"
HOMEPAGE="http://www.motifzone.org/"
SRC_URI="ftp://ftp.ics.com/openmotif/2.3/${PV}/${P}.tar.gz
	doc? ( http://www.motifzone.net/files/documents/${P}-manual.pdf.tgz )"

LICENSE="MOTIF doc? ( OPL )"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE="doc xft jpeg png examples"

RDEPEND="
	x11-libs/libXmu
	x11-libs/libXaw
	x11-libs/libXp
	x11-proto/printproto
	xft? ( x11-libs/libXft )
	jpeg? ( media-libs/jpeg )
	png? ( media-libs/libpng )
	>=x11-libs/motif-config-0.10-r2"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	x11-misc/xbitmaps"

PROVIDE="virtual/motif"

pkg_setup() {
	# multilib includes don't work right in this package...
	[ -n "${ABI}" ] && append-flags "-I/usr/include/gentoo-multilib/${ABI}"
}

src_compile() {
	# get around some LANG problems in make (#15119)
	unset LANG

	# bug #80421
	filter-flags -ftracer

	append-flags -fno-strict-aliasing

	econf --with-x \
		$(use_enable xft) \
		$(use_enable jpeg) \
		$(use_enable png) || die "configuration failed"

	emake -j1 || die "make failed, if you have lesstif installed removed it, compile openmotif and recompile lesstif"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	# cleanups
	rm -fR "${D}"/usr/$(get_libdir)/X11
	rm -fR "${D}"/usr/$(get_libdir)/X11/bindings
	rm -fR "${D}"/usr/include/X11/

	list="/usr/share/man/man1/mwm.1 /usr/share/man/man4/mwmrc.4"
	for f in $list; do
		dosed 's:/usr/lib/X11/\(.*system\\&\.mwmrc\):/etc/X11/mwm/\1:g' "$f"
		dosed 's:/usr/lib/X11/app-defaults:/etc/X11/app-defaults:g' "$f"
	done

	einfo "Fixing binaries"
	dodir /usr/$(get_libdir)/openmotif-2.3
	for file in `ls "${D}"/usr/bin`
	do
		mv "${D}"/usr/bin/${file} "${D}"/usr/$(get_libdir)/openmotif-2.3/${file}
	done

	einfo "Fixing libraries"
	mv "${D}"/usr/$(get_libdir)/* "${D}"/usr/$(get_libdir)/openmotif-2.3/

	einfo "Fixing includes"
	dodir /usr/include/openmotif-2.3/
	mv "${D}"/usr/include/* "${D}"/usr/include/openmotif-2.3

	einfo "Fixing man pages"
	mans="1 3 4 5"
	for man in $mans; do
		dodir /usr/share/man/man${man}
		for file in `ls "${D}"/usr/share/man/man${man}`
		do
			file=${file/.${man}/}
			mv "${D}"/usr/share/man/man$man/${file}.${man} "${D}"/usr/share/man/man${man}/${file}-openmotif-2.3.${man}
		done
	done

	# install docs
	dodoc README RELEASE RELNOTES BUGREPORT TODO

	use doc && cp "${WORKDIR}"/*.pdf "${D}"/usr/share/doc/${PF}

	if ( use examples )
	then
		dodir /usr/share/doc/${PF}/demos
		mv "${D}"/usr/share/Xm "${D}"/usr/share/doc/${PF}/demos
	else
		rm -rf "${D}"/usr/share/Xm
	fi

	# profile stuff
	dodir /etc/env.d
	echo "LDPATH=/usr/$(get_libdir)/openmotif-2.3" > "${D}"/etc/env.d/15openmotif-2.3
	dodir /usr/$(get_libdir)/motif
	echo "PROFILE=openmotif-2.3" > "${D}"/usr/$(get_libdir)/motif/openmotif-2.3
}

pkg_postinst() {
	/usr/bin/motif-config -s
}

pkg_postrm() {
	/usr/bin/motif-config -s
}
