# Author Sean Mitchell <sean@arawak.on.ca>

S=${WORKDIR}/${P}
DESCRIPTION="Doxygen is a documentation system for C++, Java, IDL (Corba, Microsoft and KDE-DCOP flavors) and C"

SRC_URI="ftp://ftp.stack.nl/pub/users/dimitri/doxygen-1.2.8.1.src.tar.gz"
HOMEPAGE="http://www.stack.nl/~dimitri/doxygen"

DEPEND="qt? ( >=x11-libs/qt-x11-2.2.1 )"

src_compile()
{
   if [ "`use qt`" ]
   then
      CONFIGURE_OPTIONS="--install install --prefix ${D}/usr --with-doxywizard"
   else
      CONFIGURE_OPTIONS="--install install --prefix ${D}/usr"
   fi

   try ./configure ${CONFIGURE_OPTIONS}
   try make CFLAGS=\"${CFLAGS} -Wall\" all
}

src_install()
{
   try make install
   dodoc README VERSION LICENSE LANGUAGE.HOWTO PLATFORMS
}
