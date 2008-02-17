# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/openmotif/openmotif-2.3.0-r1.ebuild,v 1.5 2008/02/17 11:44:27 ulm Exp $

inherit eutils flag-o-matic multilib autotools

DESCRIPTION="Open Motif"
HOMEPAGE="http://www.motifzone.org/"
SRC_URI="ftp://ftp.ics.com/openmotif/2.3/${PV}/${P}.tar.gz
	doc? ( http://www.motifzone.net/files/documents/${P}-manual.pdf.tgz )"

LICENSE="MOTIF doc? ( OPL )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc examples jpeg png xft"

# make people unmerge motif-config and all previous slots
# since the slotting is finally gone now
RDEPEND="!x11-libs/motif-config
	!x11-libs/lesstif
	!<=x11-libs/openmotif-2.3.0
	x11-libs/libXmu
	x11-libs/libXaw
	x11-libs/libXp
	xft? ( x11-libs/libXft )
	jpeg? ( media-libs/jpeg )
	png? ( media-libs/libpng )"
DEPEND="${RDEPEND}
	x11-misc/xbitmaps
	x11-proto/printproto"

PROVIDE="virtual/motif"

pkg_setup() {
	# clean up orphaned cruft left over by motif-config
	local i count=0
	local stalesyms="usr/bin/mwm \
				usr/bin/uil \
				usr/bin/xmbind \
				usr/include/Xm \
				usr/include/uil \
				usr/include/Mrm"

	for i in ${stalesyms} ; do
		if [[ -L "${ROOT}"${i} ]] ; then
			einfo "Cleaning up orphaned ${ROOT}${i} symlink ..."
			rm -f "${ROOT}"${i}
		fi
	done

	for i in "${ROOT}"usr/$(get_libdir)/lib{Xm,Uil,Mrm}.*; do
		if [[ -L "${i}" && $(readlink "${i}") =~ (openmo|less)tif- ]]; then
			einfo "Cleaning up orphaned ${i} symlink ..."
			rm -f "${i}"
		fi
	done

	cd "${ROOT}"usr/share/man
	for i in $(find . -type l); do
		if [[ $(readlink "${i}") =~ -(openmo|less)tif- ]]; then
			(( count++ ))
			rm -f "${i}"
		fi
	done
	[[ ${count} -ne 0 ]] && \
		einfo "Cleaned up ${count} orphaned symlinks in ${ROOT}usr/share/man"
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-sensitivity-invisible.patch"

	# disable compilation of demo binaries
	sed -i -e 's/^[ \t]*demos//' Makefile.in
}

src_compile() {
	# get around some LANG problems in make (#15119)
	unset LANG

	# bug #80421
	filter-flags -ftracer

	# multilib includes don't work right in this package...
	has_multilib_profile && append-flags "-I$(get_ml_incdir)"

	# feel free to fix properly if you care
	append-flags -fno-strict-aliasing

	econf --with-x \
		$(use_enable xft) \
		$(use_enable jpeg) \
		$(use_enable png)

	emake -j1 || die "emake failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "emake install failed"

	newbin "${FILESDIR}"/motif-config-2.3 motif-config
	dosed "s:@@LIBDIR@@:$(get_libdir):g" /usr/bin/motif-config

	# mwm default configs
	insinto /etc/X11/app-defaults
	doins "${FILESDIR}"/Mwm.defaults

	for f in /usr/share/man/man1/mwm.1 /usr/share/man/man4/mwmrc.4; do
		dosed 's:/usr/lib/X11/\(.*system\\&\.mwmrc\):/etc/X11/mwm/\1:g' ${f}
		dosed 's:/usr/lib/X11/app-defaults:/etc/X11/app-defaults:g' ${f}
	done

	dodir /etc/X11/mwm
	mv -f "${D}"/usr/$(get_libdir)/X11/system.mwmrc "${D}"/etc/X11/mwm
	dosym /etc/X11/mwm/system.mwmrc /usr/$(get_libdir)/X11/

	if use examples ; then
		dodir /usr/share/doc/${PF}/demos
		mv "${D}"/usr/share/Xm/* "${D}"/usr/share/doc/${PF}/demos
	fi
	rm -rf "${D}"/usr/share/Xm

	# documentation
	dodoc README RELEASE RELNOTES BUGREPORT TODO
	use doc && cp "${WORKDIR}"/*.pdf "${D}"/usr/share/doc/${PF}
}
