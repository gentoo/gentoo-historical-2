# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/pwlib/pwlib-1.10.10-r2.ebuild,v 1.6 2010/03/23 12:57:13 ranger Exp $

EAPI="1"

inherit eutils flag-o-matic multilib autotools toolchain-funcs

IUSE="alsa debug ieee1394 ipv6 ldap oss sasl sdl ssl v4l v4l2 xml"

DESCRIPTION="Portable Multiplatform Class Libraries used by several VoIP applications"
HOMEPAGE="http://www.ekiga.org"
SRC_URI="http://www.ekiga.org/admin/downloads/latest/sources/sources/${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 sparc x86"

RDEPEND="alsa? ( media-libs/alsa-lib )
	ieee1394? ( media-libs/libdv
		sys-libs/libraw1394
		media-libs/libdc1394:1 )
	ldap? ( >=net-nds/openldap-2.3.35 )
	sasl? ( dev-libs/cyrus-sasl )
	sdl? ( media-libs/libsdl )
	ssl? ( dev-libs/openssl )
	xml? ( dev-libs/expat )"
DEPEND="${RDEPEND}
	>=sys-devel/bison-1.28
	>=sys-devel/flex-2.5.4a
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# filter out -O3, -Os and -mcpu embedded compiler flags
	sed -i \
		-e "s:-mcpu=\$(CPUTYPE)::" \
		-e "s:-O3 -DNDEBUG:-DNDEBUG:" \
		-e "s:-Os::" \
		make/unix.mak

	# don't break make install if there are no plugins to install
	epatch "${FILESDIR}"/pwlib-1.8.7-instplugins.diff

	# use sdl-config to query required libraries
	epatch "${FILESDIR}"/pwlib-1.9.3-sdl-configure.patch

	# this patch fixes bugs: #145424 and #140358
	epatch "${FILESDIR}"/${PN}-1.10.2-asm.patch

	# security - we obviousl need to patch..
	epatch "${FILESDIR}"/pwlib-1.10.1-vsprintf.patch

	eautoconf || die "autoconf failed"
}

src_compile() {
	tc-export CC CXX
	local myconf=""
	# may cause ICE (bug #70638)
	filter-flags -fstack-protector
	# disable-alsa breaks oss, see bug 127677
	use alsa && myconf="--enable-alsa"

	# disabling avc, bug 272848
	econf \
		--enable-plugins \
		--disable-avc \
		$(use_enable v4l2) \
		$(use_enable v4l) \
		$(use_enable ieee1394 dc) \
		$(use_enable oss) \
		$(use_enable ipv6) \
		$(use_enable sdl) \
		$(use_enable ssl openssl) \
		$(use_enable debug exceptions) \
		$(use_enable debug memcheck) \
		$(use_enable ldap openldap) \
		$(use_enable sasl) \
		$(use_enable xml expat) \
		${myconf} \
		|| die "configure failed"

	# Horrible hack to strip out -L/usr/lib to allow upgrades
	# problem is it adds -L/usr/lib before -L${S} when SSL is
	# enabled.  Same thing for -I/usr/include.
#	sed -i  -e "s:^\(LDFLAGS.*\)-L/usr/lib:\1:" \
#		-e "s:^\(STDCCFLAGS.*\)-I/usr/include:\1:" \
#		${S}/make/ptbuildopts.mak

#	sed -i  -e "s:^\(LDFLAGS[\s]*=.*\) -L/usr/lib:\1:" \
#		-e "s:^\(LDFLAGS[\s]*=.*\) -I/usr/include:\1:" \
#		-e "s:^\(CCFLAGS[\s]*=.*\) -I/usr/include:\1:" \
#		${S}/make/ptlib-config

	emake -j1 opt || die "make failed"
}

src_install() {
	local libdir libname

	libdir=$(get_libdir)

	# makefile doesn't create ${D}/usr/bin
	make PREFIX=/usr DESTDIR="${D}" install || die "install failed"

	## vv will try to fix the mess below, requires a lot of patching though...

	# update 2005/08/22:
	#
	# locations in *.mak files haven been fixed
	# directories have been replaced w/ symlinks
	# (left to not break things, doing some testing atm)

	# Note: reactivating this seems to be the only easy solution to slot pwlib ebuild
	#       and keep applications happy (e.g. gnomemeeting / ekiga)

#	dosym /usr/include /usr/share/pwlib/include
#	dosym /usr/${libdir} /usr/share/pwlib/${libdir}
#
#	# just in case...
#	if [[ "${libdir}" = "lib64" ]]; then
#		dosym /usr/share/pwlib/lib64 /usr/share/pwlib/lib
#	fi

	## ^^ bad stuff

	# fix symlink
	libname=$(basename "`ls "${D}"/usr/${libdir}/libpt_*_*_r.so.${PV}`")
	rm "${D}"/usr/${libdir}/libpt.so
	dosym ${libname} /usr/${libdir}/libpt.so

	# fix makefiles to use headers from /usr/include and libs from /usr/lib
	# instead of /usr/share/pwlib
	# Note: change to /usr/include/pwlib-${PV} (or whereever includes will be)
	#       once pwlib ebuilds get slotted
	sed -i  -e "s:-I\$(PWLIBDIR)\(/include[a-zA-Z0-9_/-]\+\):-I/usr/include\1:g" \
		-e "s:-I\$(PWLIBDIR)/include::g" \
		-e "s:^\(PW_LIBDIR[ \t]\+=\).*:\1 /usr/${libdir}:" \
		"${D}"/usr/share/pwlib/make/*.mak

	# dodgy configure/makefiles forget to expand this
	# Note: change to /usr/share/pwlib/${PV} (or whatever PWLIBDIR should point to)
	#       once pwlib ebuilds get slotted
	sed -i -e "s:\${exec_prefix}:/usr:" \
		"${D}"/usr/bin/ptlib-config \
		"${D}"/usr/share/pwlib/make/ptlib-config

	# copy version.h
	insinto /usr/share/pwlib
	doins version.h

	dodoc ReadMe.txt ReadMe_QOS.txt History.txt
	dohtml mpl-1.0.htm
}
